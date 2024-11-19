import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booksuccess_controller.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart';

class BooksuccessViews extends GetView<BooksuccessController> {
  const BooksuccessViews({super.key});

 @override
  Widget build(BuildContext context) {
    // Jalankan logika untuk memeriksa status booking
    controller.checkBookingStatus();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0093B7),
        title: const Text(
          'Explore',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        // Jika booking sukses, tampilkan UI
        if (controller.isBookingSuccessful.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Successful',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }

        // Jika tidak ada data booking, tampilkan halaman kosong
        return const SizedBox.shrink();
      }),
      bottomNavigationBar:
          const CustomBottomNavigationBar(), // Navigation Bar
    );
  }
}