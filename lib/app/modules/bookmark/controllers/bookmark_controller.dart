// File 4: /lib/app/modules/bookmark/controllers/bookmark_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/service_model.dart';

class BookmarkController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Service> bookmarkedServices = <Service>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToBookmarkedServices();
  }

  @override
  void onClose() {
    super.onClose();
    _unsubscribe();
  }

  StreamSubscription<QuerySnapshot>? _subscription;

  void _listenToBookmarkedServices() {
    isLoading.value = true;
    _subscription = _firestore
        .collection('services')
        .where('isBookmarked', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      bookmarkedServices.value =
          snapshot.docs.map((doc) => Service.fromFirestore(doc)).toList();
      isLoading.value = false;
    }, onError: (error) {
      Get.snackbar(
        'Error',
        'Failed to fetch bookmarked services: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      isLoading.value = false;
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
  }
}