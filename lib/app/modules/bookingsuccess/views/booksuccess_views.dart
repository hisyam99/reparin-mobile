import 'dart:async'; // Untuk Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart'; // Untuk audio player
import '../controllers/booksuccess_controller.dart';
import 'package:reparin_mobile/app/modules/navbar/views/navbar_view.dart';

class BooksuccessViews extends GetView<BooksuccessController> {
  const BooksuccessViews({super.key});

  @override
  Widget build(BuildContext context) {
    // Audio Player instance
    final AudioPlayer audioPlayer = AudioPlayer();

    // URL untuk lagu jingle pendek (Anda bisa mengganti URL di sini)
    const String jingleUrl = 'https://www.myinstants.com/media/sounds/thick-of-it.mp3';

    // Mulai memainkan jingle saat halaman dimuat
    audioPlayer.play(UrlSource(jingleUrl));

    // Navigasi otomatis ke halaman /home setelah 3 detik
    Timer(const Duration(seconds: 8), () {
      audioPlayer.stop(); // Hentikan jingle sebelum navigasi
      Get.offAllNamed('/home');
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
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
      bottomNavigationBar: const CustomBottomNavigationBar(), // Navigation Bar
    );
  }
}
