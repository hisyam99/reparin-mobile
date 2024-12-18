import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:reparin_mobile/app/data/services/authentication/controllers/authentication_controller.dart';

class LoginController extends GetxController {
  final AuthenticationController _authController =
      Get.find<AuthenticationController>();

  TextEditingController get emailController => _authController.emailController;
  TextEditingController get passwordController =>
      _authController.passwordController;

  Future<void> login() async {
    try {
      _authController.emailController.text = emailController.text;
      _authController.passwordController.text = passwordController.text;

      await _authController.login();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login gagal: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool validateInputs() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text.trim());
  }
}
