import 'dart:async'; // Import Timer
import 'package:get/get.dart';

class BooksuccessController extends GetxController {
var isBookingSuccessful = false.obs;

  // Logika untuk memeriksa status booking
  void checkBookingStatus() {
    // Simulasikan bahwa informasi keberhasilan booking dikirimkan melalui argument GetX
    if (Get.arguments != null && Get.arguments['bookingSuccess'] == true) {
      isBookingSuccessful.value = true;

      // Setelah 3 detik, navigasikan ke halaman /home
      Timer(const Duration(seconds: 5), () {
        Get.offAllNamed('/home');
      });
    }
  }
}
