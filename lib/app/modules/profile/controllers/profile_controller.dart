import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../data/models/profile_model.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final profile = Rx<Profile>(Profile.empty());
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // Stream subscription for real-time updates
  StreamSubscription<DocumentSnapshot>? _profileSubscription;

  @override
  void onInit() {
    super.onInit();
    // Instead of just loading once, we'll listen to real-time updates
    setupProfileListener();
  }

  void setupProfileListener() {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _profileSubscription = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .listen(
        (DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>;
            print('Raw Firestore data:');
            print('imagePath from Firestore: ${data['imagePath']}');
            try {
              profile.value = Profile.fromFirestore(snapshot);
              print('Profile after conversion:');
              print(
                  'Image Path in profile object: ${profile.value.imagePath.value}');
              if (profile.value.imagePath.value.isEmpty) {
                print('Warning: Image path is empty after conversion');
              }
              // Update text controllers with Firestore data
              nameController.text = profile.value.name.value;
              phoneController.text = profile.value.phone.value;
              emailController.text = profile.value.email.value;
            } catch (e) {
              print('Error converting Firestore data to Profile: $e');
            }
          } else {
            print('Document does not exist');
          }
        },
        onError: (error) {
          print('Error in profile stream: $error');
        },
      );
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        emailController.text = currentUser.email ?? '';
        profile.value.email.value = currentUser.email ?? '';
        final DocumentSnapshot doc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          profile.value = Profile.fromFirestore(doc);
          nameController.text = profile.value.name.value;
          phoneController.text = profile.value.phone.value;
        } else {
          print('User document does not exist.');
          Get.snackbar(
            'Error',
            'User document does not exist.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      } else {
        print('No current user found.');
        Get.snackbar(
          'Error',
          'No current user found.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      print('Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> updateProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File imageFile = File(image.path);
        // Upload to Firebase Storage
        final String userId = _auth.currentUser?.uid ?? '';
        final Reference ref =
            _storage.ref().child('profile_images/$userId.jpg');
        // Show loading indicator
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        // Upload file
        await ref.putFile(imageFile);
        // Get download URL
        final String downloadURL = await ref.getDownloadURL();
        // Update Firestore - this will trigger the stream listener
        await _firestore
            .collection('users')
            .doc(userId)
            .update({'imagePath': downloadURL});
        // Close loading dialog
        Get.back();
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to update profile picture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<bool> updateProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;
      final userData = {
        'name': profile.value.name.value,
        'phone': profile.value.phone.value,
        'imagePath': profile.value.imagePath.value,
      };
      await _firestore.collection('users').doc(userId).update(userData);
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Delete the image from Firebase Storage
      final Reference ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.delete();

      // Update Firestore to remove the image path
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'imagePath': ''});

      // Update the local profile
      profile.update((val) {
        if (val != null) val.imagePath.value = '';
      });

      Get.snackbar(
        'Success',
        'Profile picture removed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove profile picture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    _profileSubscription?.cancel(); // Cancel the stream subscription
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
