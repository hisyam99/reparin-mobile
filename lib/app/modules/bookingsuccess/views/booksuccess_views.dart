import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booksuccess_controller.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart';

class BooksuccessViews extends GetView<BooksuccessController> {
  const BooksuccessViews({super.key});

 @override
  Widget build(BuildContext context) {
    // Jalankan logika untuk check status booking saat widget diinisialisasi
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
        // Jika booking berhasil, tampilkan tanda centang
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

        // Default UI jika tidak ada status sukses booking
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 80,
                color: Color(0xFF0093B7),
              ),
              const SizedBox(height: 20),
              const Text(
                'What is Your Location?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'To find Nearby Service Providers.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/locationinput');
                },
                child: const Text(
                  'Enter Location Manually',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar:
          const CustomBottomNavigationBar(), // Navigation Bar
    );
  }
}