// File 2: /lib/app/modules/service/controllers/service_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/service_model.dart';

class ServiceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Service> services = <Service>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('services').get();
      services.value =
          snapshot.docs.map((doc) => Service.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch services: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Service> filterServicesByLocation(String query) {
    if (query.isEmpty) {
      return services;
    }
    query = query.toLowerCase();
    return services.where((service) {
      String serviceAddress = service.address.toLowerCase();
      return serviceAddress.contains(query);
    }).toList();
  }

  Future<void> toggleBookmark(String serviceId) async {
    try {
      final serviceIndex =
          services.indexWhere((service) => service.id == serviceId);
      if (serviceIndex != -1) {
        final updatedService = services[serviceIndex]
            .copyWith(isBookmarked: !services[serviceIndex].isBookmarked);
        services[serviceIndex] = updatedService;
        await _firestore
            .collection('services')
            .doc(serviceId)
            .update({'isBookmarked': updatedService.isBookmarked});
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update bookmark: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}
