import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceProviderController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final tabs = ['Services', 'About', 'Gallery', 'Review'];

  final providerName = 'Jenny Wilson';
  final providerSpecialty = 'Mobile Phone Repair';
  final providerLocation = 'New York';
  final providerImage = 'https://example.com/jenny_wilson.jpg';

  final customerCount = 2500;
  final yearsExperience = 3;
  final rating = 4.8;
  final reviewCount = 1400;

  final services = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    _loadServices();
  }

  void _loadServices() {
    services.addAll([
      Service(
        name: 'Mobile Device Repair',
        price: 15.00,
        imageUrl: 'https://example.com/mobile_repair.jpg',
      ),
      // Add more services here
    ]);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class Service {
  final String name;
  final double price;
  final String imageUrl;

  Service({required this.name, required this.price, required this.imageUrl});
}