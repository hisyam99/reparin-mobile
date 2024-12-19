import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reparin_mobile/app/modules/maps/controllers/maps_controller.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/service_order_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/services/notification_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/location_controller.dart';
import '../../../data/services/localstorageservice.dart';

class ServiceBookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessagingHandler _notificationHandler = FirebaseMessagingHandler();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ImagePicker _picker = ImagePicker();
  final LocalStorageService _localStorage = LocalStorageService();

  final Rx<Profile> userProfile = Profile.empty().obs;
  final RxBool isLoading = false.obs;
  
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final GetConnectController controller = Get.put(GetConnectController());
  
  // Media handling
  Rx<File?> imageFile = Rx<File?>(null);
  Rx<File?> videoFile = Rx<File?>(null);
  Rx<VideoPlayerController?> videoPlayerController = Rx<VideoPlayerController?>(null);
  RxBool isVideo = false.obs;
  
  final RxBool isSyncing = false.obs;
  final RxInt pendingOrdersCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    initNotifications();
    _updatePendingOrdersCount();
  }

  Future<void> _saveOrderLocally(Map<String, dynamic> orderData) async {
    await _localStorage.savePendingOrder(orderData);
    _updatePendingOrdersCount();
    Get.snackbar(
      'Offline Mode',
      'Order saved locally. Will sync when internet connection is restored.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
    );
  }

  void _updatePendingOrdersCount() {
    pendingOrdersCount.value = _localStorage.getPendingOrders().length;
  }

  Future<void> initNotifications() async {
    await _notificationHandler.initLocalNotification();
  }

  Future<void> loadUserProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          userProfile.value = Profile.fromFirestore(doc);
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> showBookingSuccessNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'booking_channel', 
      'Booking Notifications',
      channelDescription: 'Notifications for service bookings',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: false,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Booking Successful!',
      'Your service has been booked successfully. We will contact you soon.',
      platformChannelSpecifics,
    );
  }

  Future<bool> createServiceOrder({
    required String serviceType,
    required String providerName,
    required double price,
  }) async {
    try {
      isLoading.value = true;
      
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'Please login first');
        return false;
      }

      final orderData = {
        'userId': userId,
        'serviceType': serviceType,
        'providerName': providerName,
        'price': price,
        'description': descriptionController.text,
        'userPhone': userProfile.value.phone.value,
        'userEmail': userProfile.value.email.value,
        'userName': userProfile.value.name.value,
        'orderDate': DateTime.now().toIso8601String(),
        'address': addressController.text,
        'status': 'pending',
      };

      try {
        // Try to send to Firebase
        await _firestore.collection('service_orders').add(orderData);
        await showBookingSuccessNotification();
        Get.snackbar(
          'Success',
          'Service order created successfully',
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        // If Firebase fails, store locally
        await _saveOrderLocally(orderData);
        return true;
      }
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create service order: $e',
        snackPosition: SnackPosition.TOP,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      
      if (pickedImage != null) {
        imageFile.value = File(pickedImage.path);
        videoFile.value = null;
        isVideo.value = false;
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> pickVideo(ImageSource source) async {
    try {
      final XFile? pickedVideo = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );
      
      if (pickedVideo != null) {
        videoFile.value = File(pickedVideo.path);
        imageFile.value = null;
        isVideo.value = true;
        
        if (videoPlayerController.value != null) {
          await videoPlayerController.value!.dispose();
        }
        
        videoPlayerController.value = VideoPlayerController.file(videoFile.value!)
          ..initialize().then((_) {
            update();
          });
      }
    } catch (e) {
      print('Error picking video: $e');
      Get.snackbar('Error', 'Failed to pick video');
    }
  }

  void showMediaPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _showMediaTypeSelection(context, ImageSource.camera);
                }
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _showMediaTypeSelection(context, ImageSource.gallery);
                }
              ),
            ],
          ),
        );
      }
    );
  }

  void _showMediaTypeSelection(BuildContext context, ImageSource source) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Photo'),
                onTap: () {
                  pickImage(source);
                  Navigator.pop(context);
                }
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Video'),
                onTap: () {
                  pickVideo(source);
                  Navigator.pop(context);
                }
              ),
            ],
          ),
        );
      }
    );
  }

  
  // Future<void> syncPendingOrders() async {
  //   if (isSyncing.value) return;

  //   try {
  //     isSyncing.value = true;
  //     List<Map<String, dynamic>> pendingOrders = _localStorage.getPendingOrders();
      
  //     if (pendingOrders.isEmpty) return;

  //     int successCount = 0;
  //     int failureCount = 0;

  //     for (int i = 0; i < pendingOrders.length; i++) {
  //       try {
  //         Map<String, dynamic> orderData = pendingOrders[i];
  //         orderData['orderDate'] = DateTime.parse(orderData['orderDate']);
          
  //         await _firestore.collection('service_orders').add(orderData);
  //         await _localStorage.removePendingOrder(i);
  //         successCount++;
          
  //         await showBookingSuccessNotification();
  //       } catch (e) {
  //         print('Error syncing order $i: $e');
  //         failureCount++;
  //       }
  //     }

  //     _updatePendingOrdersCount();
      
  //     if (successCount > 0) {
  //       Get.snackbar(
  //         'Sync Complete',
  //         'Successfully synced $successCount orders${failureCount > 0 ? '. Failed to sync $failureCount orders' : ''}',
  //         snackPosition: SnackPosition.TOP,
  //         duration: const Duration(seconds: 5),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error in syncPendingOrders: $e');
  //     Get.snackbar(
  //       'Sync Error',
  //       'Failed to sync offline orders',
  //       snackPosition: SnackPosition.TOP,
  //     );
  //   } finally {
  //     isSyncing.value = false;
  //   }
  // }
  
  // @override
  // void onClose() {
  //   descriptionController.dispose();
  //   addressController.dispose();
  //   videoPlayerController.value?.dispose();
  //   super.onClose();
  // }

  Future<void> useCurrentLocation() async {
    try {
      isLoading.value = true;

      final mapsController = Get.find<MapsController>();
      await mapsController.getCurrentLocation();

      if (mapsController.currentPosition.value != null) {
        Position position = mapsController.currentPosition.value!;

        try {
          final url = 'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json&addressdetails=1';
          final response = await GetConnect().get(url);

          if (response.statusCode == 200 && response.body != null) {
            final data = response.body;
            if (data['display_name'] != null) {
              final selectedAddress = data['display_name'];
              addressController.text = selectedAddress;
              await updateAddress(selectedAddress);
            } else {
              Get.snackbar('Error', 'No address found for this location');
            }
          } else {
            // Handle offline case for address lookup
            addressController.text = 'Lat: ${position.latitude}, Long: ${position.longitude}';
          }
        } catch (e) {
          // If address lookup fails, use coordinates
          addressController.text = 'Lat: ${position.latitude}, Long: ${position.longitude}';
          print('Error fetching address: $e');
        }
      } else {
        Get.snackbar('Error', 'Failed to get current location');
      }
    } catch (e) {
      print('Error using current location: $e');
      Get.snackbar('Error', 'Failed to fetch location');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(String address) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).set({
          'address': address,
        }, SetOptions(merge: true));

        Get.snackbar('Success', 'Address updated successfully');
      } else {
        Get.snackbar('Error', 'User not logged in');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address: $e');
    }
  }
  
}