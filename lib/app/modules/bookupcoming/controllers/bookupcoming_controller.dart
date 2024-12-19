import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/booking_data_model.dart';

class BookupcomingController extends GetxController {
  static BookupcomingController get to => Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxInt currentTab = 0.obs;
  final RxInt currentNavIndex = 2.obs;
  final RxList<BookingData> bookings = <BookingData>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final querySnapshot = await _firestore
          .collection('service_orders')
          .where('userId', isEqualTo: userId)
          .get();

      final fetchedBookings = querySnapshot.docs.map((doc) {
        // Handle the case where orderDate might be a String or Timestamp
        final data = doc.data();
        if (data['orderDate'] is String) {
          // If it's a String, convert it to DateTime then to Timestamp
          data['orderDate'] =
              Timestamp.fromDate(DateTime.parse(data['orderDate']));
        }
        return BookingData.fromFirestore(doc);
      }).toList();

      bookings.assignAll(fetchedBookings);
    } catch (e) {
      print('Error fetching bookings: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch bookings. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Computed lists
  List<BookingData> get upcomingBookings =>
      bookings.where((booking) => booking.status == 'pending').toList();

  List<BookingData> get completedBookings =>
      bookings.where((booking) => booking.status == 'completed').toList();

  List<BookingData> get cancelledBookings =>
      bookings.where((booking) => booking.status == 'cancelled').toList();

  List<BookingData> get currentBookings {
    switch (currentTab.value) {
      case 0:
        return upcomingBookings;
      case 1:
        return completedBookings;
      case 2:
        return cancelledBookings;
      default:
        return [];
    }
  }

  Future<void> showCancellationDialog(String bookingId) async {
    final RxString selectedReason = RxString('');
    final reasons = [
      'Changed my mind',
      'Found another service provider',
      'Schedule conflict',
      'Price too high',
      'Emergency situation',
      'Other'
    ];

    await Get.dialog(
      AlertDialog(
        title: const Text('Cancel Booking'),
        content: SingleChildScrollView(
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Are you sure you want to cancel this booking?'),
                  const SizedBox(height: 16),
                  const Text('Please select a reason:'),
                  const SizedBox(height: 8),
                  ...reasons.map((reason) => RadioListTile<String>(
                        title: Text(reason),
                        value: reason,
                        groupValue: selectedReason.value,
                        onChanged: (value) =>
                            selectedReason.value = value ?? '',
                      )),
                ],
              )),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          Obx(() => TextButton(
                onPressed: selectedReason.value.isEmpty
                    ? null
                    : () async {
                        Get.back();
                        await cancelBooking(bookingId, selectedReason.value);
                      },
                child: const Text('Yes'),
              )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> showDeleteConfirmationDialog(String bookingId) async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Delete Booking'),
        content: const Text(
          'Are you sure you want to delete this cancelled booking? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await deleteBooking(bookingId);
            },
            child: const Text(
              'Yes, Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      isLoading.value = true;
      await _firestore.collection('service_orders').doc(bookingId).update({
        'status': 'cancelled',
        'cancellationReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Booking cancelled successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      await fetchBookings();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel booking: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('service_orders').doc(bookingId).delete();

      Get.snackbar(
        'Success',
        'Booking history deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      await fetchBookings();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete booking: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }
}
