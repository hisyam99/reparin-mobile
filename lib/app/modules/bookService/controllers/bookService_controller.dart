import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BookServiceController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final genderOptions = ['Male', 'Female', 'Other'];
  final Rx<String?> selectedGender = Rx<String?>(null);

  final countryOptions = ['United States', 'Canada', 'United Kingdom', 'Australia', 'Other'];
  final Rx<String?> selectedCountry = Rx<String?>(null);

  final countryCodes = ['+1', '+44', '+61', '+86', '+91'];
  final Rx<String> selectedCountryCode = Rx<String>('+1');

  @override
  void onInit() {
    super.onInit();
    nameController.text = 'Enter Username';
    emailController.text = 'Enter Email';
    phoneController.text = 'Enter Phone Number';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void onContinuePressed() {
    // Implement the logic for when the Continue button is pressed
    print('Continue button pressed');
    print('Name: ${nameController.text}');
    print('Email: ${emailController.text}');
    print('Gender: ${selectedGender.value}');
    print('Phone: ${selectedCountryCode.value}${phoneController.text}');
    print('Country: ${selectedCountry.value}');
  }
}