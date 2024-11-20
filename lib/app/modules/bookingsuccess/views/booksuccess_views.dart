import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booksuccess_controller.dart';

class BooksuccessViews extends GetView<BooksuccessController> {
  const BooksuccessViews({super.key});

  @override
Widget build(BuildContext context) {
  // Automatically navigate to the home page after 5 seconds
  Timer(const Duration(seconds: 5), () {
    Get.offAllNamed('/home');
  });

  // Explicitly call to play the jingle if a URL exists
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.audioUrl.value.isNotEmpty) {
      controller.playJingle();
    }
  });
  
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
      body: Center(
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
      ),
    );
  }
}
