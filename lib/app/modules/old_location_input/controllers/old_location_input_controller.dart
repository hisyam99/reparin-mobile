import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationInputController extends GetxController {
  final searchController = TextEditingController();
  final searchResults = <Location>[].obs;

  void onSearchChanged(String value) {
    // Implement search logic here
    if (value.isNotEmpty) {
      searchResults.assignAll([
        Location('Galaxy Mall Surabaya', 'Jl. Dharmahusada Indah Timur, Surabaya, Indonesia'),
        Location('Tunjungan Plaza', 'Jl. Basuki Rahmat, Surabaya, Indonesia'),
        Location('Pakuwon Mall', 'Jl. Puncak Indah Lontar, Surabaya, Indonesia'),
      ]);
    } else {
      searchResults.clear();
    }
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
  }

  void useCurrentLocation() {
    // Implement current location logic here
    searchController.text = 'Current Location';
    searchResults.clear();
    Get.snackbar('Current Location', 'Using current location...');
  }

  void selectLocation(Location location) {
    // Handle location selection
    Get.back(result: location);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class Location {
  final String name;
  final String address;

  Location(this.name, this.address);
}
