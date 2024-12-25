// File 1: /lib/app/modules/admin_dashboard/controllers/add_service_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/service_model.dart';
import '../../../data/services/location_controller.dart';

class AddServiceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final GetConnectController _locationController = Get.put(GetConnectController());

  final titleController = TextEditingController().obs;
  final providerController = TextEditingController().obs;
  final priceController = TextEditingController().obs;
  final imageController = TextEditingController().obs;
  final addressController = TextEditingController().obs;

  final RxBool isLoading = false.obs;
  final Rx<File?> pickedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        pickedImage.value = File(pickedFile.path);
        imageController.value.text = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> addService() async {
    try {
      isLoading.value = true;
      if (pickedImage.value == null) {
        throw 'Image is required';
      }
      final imageUrl = await _uploadImage(pickedImage.value!);

      // Cari koordinat dari alamat yang dimasukkan
      await _locationController.searchAddress(addressController.value.text);
      if (_locationController.addresses.isEmpty) {
        throw 'No address found for the given location';
      }
      final selectedAddress = _locationController.addresses.first;
      final latitude = double.parse(selectedAddress.lat);
      final longitude = double.parse(selectedAddress.lon);

      final service = Service(
        id: _firestore.collection('services').doc().id,
        title: titleController.value.text,
        provider: providerController.value.text,
        price: double.parse(priceController.value.text),
        image: imageUrl,
        longitude: longitude,
        latitude: latitude,
        address: addressController.value.text,
      );

      await _firestore.collection('services').doc(service.id).set(service.toJson());

      Get.snackbar(
        'Success',
        'Service added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      // Clear the form
      titleController.value.clear();
      providerController.value.clear();
      priceController.value.clear();
      imageController.value.clear();
      addressController.value.clear();
      pickedImage.value = null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add service: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      final ref = _storage
          .ref()
          .child('service_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'Failed to upload image: ${e.toString()}';
    }
  }
}