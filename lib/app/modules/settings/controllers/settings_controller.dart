import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/bookingsuccess/controllers/booksuccess_controller.dart';

class SettingsController extends GetxController {
  var jingleUrl = ''.obs; // Reactive variable for the jingle URL

  void updateJingleUrl(String url) {
    jingleUrl.value = url;
    // Update the audio URL in BooksuccessController
    Get.find<BooksuccessController>().updateAudioUrl(url);
  }
}