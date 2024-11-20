// File 1: /lib/app/modules/microphone/controllers/microphone_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get_storage/get_storage.dart';

class MicrophoneController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final storage = GetStorage();

  var isListening = false.obs;
  var currentText = "".obs;
  var savedTexts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    loadSavedTexts();
  }

  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      print(e);
    }
  }

  void loadSavedTexts() {
    final saved = storage.read<List>('saved_texts');
    if (saved != null) {
      savedTexts.assignAll(saved.map((e) => e.toString()));
    }
  }

  Future<void> saveCurrentText() async {
    if (currentText.value.isNotEmpty) {
      savedTexts.add(currentText.value);
      await storage.write('saved_texts', savedTexts.toList());
      Get.snackbar(
        'Success',
        'Text saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      currentText.value = "";
    }
  }

  Future<void> deleteSavedText(int index) async {
    savedTexts.removeAt(index);
    await storage.write('saved_texts', savedTexts.toList());
    Get.snackbar(
      'Success',
      'Text deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> clearAllSavedTexts() async {
    savedTexts.clear();
    await storage.write('saved_texts', savedTexts.toList());
    Get.snackbar(
      'Success',
      'All saved texts cleared',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void startListening() async {
    await checkMicrophonePermission();
    if (await Permission.microphone.isGranted) {
      isListening.value = true;
      await _speech.listen(
        onResult: (result) {
          currentText.value = result.recognizedWords;
        },
      );
    } else {
      Get.snackbar(
        'Error',
        'Microphone permission denied',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }
}
