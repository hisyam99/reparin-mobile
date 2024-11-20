import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bookService_controller.dart';

class BookServiceView extends GetView<BookServiceController> {
  const BookServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_circle_left_outlined,
                color: Colors.black, size: 24.0),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'Book Service',
            style: TextStyle(
              fontFamily: 'Inter Tight',
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Information',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('Name', controller.nameController),
                        const SizedBox(height: 16),
                        _buildTextField('Email', controller.emailController),
                        const SizedBox(height: 16),
                        _buildDropdown('Gender', controller.genderOptions,
                            controller.selectedGender),
                        const SizedBox(height: 16),
                        _buildPhoneNumberField(),
                        const SizedBox(height: 16),
                        _buildDropdown('Country', controller.countryOptions,
                            controller.selectedCountry),
                      ],
                    ),
                  ),
                ),
              ),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label, List<String> options, Rx<String?> selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
              value: selectedValue.value,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                selectedValue.value = newValue;
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.white,
              ),
            )),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Phone Number',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Obx(() => DropdownButton<String>(
                  value: controller.selectedCountryCode.value,
                  items: controller.countryCodes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.selectedCountryCode.value = newValue!;
                  },
                )),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller.phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 100.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 0.0),
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 18.0),
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/confirm_address');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0083B3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
        ),
      ),
    );
  }
}
