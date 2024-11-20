// File: /lib/app/modules/microphone/bindings/microphone_binding.dart

import 'package:get/get.dart';
import '../controllers/microphone_controller.dart';

class MicrophoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MicrophoneController>(
      () => MicrophoneController(),
    );
  }
}
