import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/service_order_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/services/notification_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ServiceBookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessagingHandler _notificationHandler = FirebaseMessagingHandler();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  final Rx<Profile> userProfile = Profile.empty().obs;
  final RxBool isLoading = false.obs;
  
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    initNotifications();
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

      final serviceOrder = ServiceOrder(
        userId: userId,
        serviceType: serviceType,
        providerName: providerName,
        price: price,
        description: descriptionController.text,
        userPhone: userProfile.value.phone.value,
        userEmail: userProfile.value.email.value,
        userName: userProfile.value.name.value,
        orderDate: DateTime.now(),
        address: addressController.text,
      );

      // Create the order in Firestore
      await _firestore.collection('service_orders').add(serviceOrder.toJson());
      
      // Show local notification
      await showBookingSuccessNotification();
      
      Get.snackbar(
        'Success',
        'Service order created successfully',
        snackPosition: SnackPosition.TOP,
      );
      
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

  @override
  void onClose() {
    descriptionController.dispose();
    addressController.dispose();
    super.onClose();
  }
}