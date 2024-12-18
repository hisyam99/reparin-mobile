import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/maps/controllers/maps_controller.dart';
import '../models/address.dart';

class GetConnectController extends GetxController {
  static const String _nominatimUrl =
      'https://nominatim.openstreetmap.org/search';

  RxList<Welcome> addresses = RxList<Welcome>([]);
  RxBool isLoading = false.obs;

  // Tambahkan TextEditingController
  final TextEditingController addressController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    // Inisialisasi MapsController jika belum ada
    if (!Get.isRegistered<MapsController>()) {
      Get.put(MapsController());
    }
  }

  @override
  void onClose() {
    // Pastikan untuk membersihkan controller saat controller dihancurkan
    addressController.dispose();
    super.onClose();
  }

  Future<void> searchAddress(String query) async {
    try {
      isLoading.value = true;
      final response = await GetConnect().get(
        '$_nominatimUrl?q=$query&format=json&addressdetails=1',
      );

      if (response.statusCode == 200) {
        final addressData = response.body as List;
        final addressList = addressData
            .map((addressJson) => Welcome.fromJson(addressJson))
            .toList();
        addresses.assignAll(addressList);
      } else {
        print("Request failed with status ${response.statusCode}");
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAddressFromCoordinates(double lat, double lon) async {
    try {
      isLoading.value = true;
      final response = await GetConnect().get(
        '$_nominatimUrl?lat=$lat&lon=$lon&format=json&addressdetails=1',
      );

      if (response.statusCode == 200) {
        final addressData = response.body;
        final address = Welcome.fromJson(addressData);
        addresses.assignAll([address]); // Simpan alamat yang diambil
      } else {
        print("Request failed with status ${response.statusCode}");
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> useCurrentLocation() async {
    try {
      isLoading.value = true;

      // Mengambil lokasi dari MapsController
      final mapsController = Get.find<
          MapsController>(); // Mengakses MapsController yang sudah diinisialisasi
      await mapsController.getCurrentLocation();

      // Pastikan lokasi ada
      if (mapsController.currentPosition.value != null) {
        Position position = mapsController.currentPosition.value!;

        // Membuat URL API untuk mendapatkan alamat berdasarkan lat, lon
        final url =
            'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json&addressdetails=1';
        print('URL: $url');

        final response = await GetConnect().get(url);

        if (response.statusCode == 200) {
          final data = response.body;
          if (data != null && data['display_name'] != null) {
            final selectedAddress = data['display_name'];

            // Update text field dengan alamat yang ditemukan
            addressController.text = selectedAddress;
          } else {
            Get.snackbar('Error', 'No address found for this location');
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to fetch location address. Status Code: ${response.statusCode}',
          );
        }
      } else {
        Get.snackbar('Error', 'Failed to get current location');
      }
    } catch (e) {
      print('Error using current location: $e');
      Get.snackbar('Error', 'Failed to fetch location');
    } finally {
      isLoading.value = false;
    }
  }
}
