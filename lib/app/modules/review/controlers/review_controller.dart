import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../old_Service/controllers/service_provider_controller.dart';

class reviewController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final currentNavIndex = 0.obs;

  final String serviceImageUrl = 'https://example.com/jenny_wilson.jpg';
  final String serviceName = 'Jenny Wilson';
  final String serviceSpecialty = 'Mobile Phone Repair';
  final int customerCount = 2500;
  final int yearsExperience = 3;
  final double rating = 4.8;
  final int reviewCount = 1400;

  final List<Service> services = [
    Service(name: 'Mobile Device Repair', price: 15.00, imageUrl: 'https://example.com/mobile_repair.jpg'),
    // Add more services here
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}