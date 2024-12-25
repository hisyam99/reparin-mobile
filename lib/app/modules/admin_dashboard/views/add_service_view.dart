import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_service_controller.dart';

class AddServiceView extends GetView<AddServiceController> {
  const AddServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.titleController.value,
                label: 'Title',
                hint: 'Enter the service title',
                validator: (value) => _validateField(value, 'Title'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.providerController.value,
                label: 'Provider',
                hint: 'Enter the service provider',
                validator: (value) => _validateField(value, 'Provider'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.priceController.value,
                label: 'Price',
                hint: 'Enter the service price',
                keyboardType: TextInputType.number,
                validator: (value) => _validateField(value, 'Price'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.longitudeController.value,
                label: 'Longitude',
                hint: 'Enter the longitude',
                keyboardType: TextInputType.number,
                validator: (value) => _validateField(value, 'Longitude'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.latitudeController.value,
                label: 'Latitude',
                hint: 'Enter the latitude',
                keyboardType: TextInputType.number,
                validator: (value) => _validateField(value, 'Latitude'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.addressController.value,
                label: 'Address',
                hint: 'Enter the service address',
                validator: (value) => _validateField(value, 'Address'),
              ),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(Get.context!).inputDecorationTheme.fillColor,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Image',
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: controller.pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(Get.context!).dividerColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: controller.pickedImage.value != null
                ? Image.file(
                    controller.pickedImage.value!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo, size: 48),
                        Text(
                          'Tap to add an image',
                          style: Theme.of(Get.context!).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () async {
                if (_validateForm()) {
                  await controller.addService();
                }
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator()
            : Text(
                'Add Service',
                style: Theme.of(Get.context!).textTheme.titleMedium,
              ),
      ),
    );
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  bool _validateForm() {
    if (controller.pickedImage.value == null) {
      Get.snackbar(
        'Error',
        'Image is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }
    if (controller.titleController.value.text.isEmpty ||
        controller.providerController.value.text.isEmpty ||
        controller.priceController.value.text.isEmpty ||
        controller.longitudeController.value.text.isEmpty ||
        controller.latitudeController.value.text.isEmpty ||
        controller.addressController.value.text.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }
    return true;
  }
}
