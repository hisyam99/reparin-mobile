import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  final box = GetStorage();
  final String pendingOrdersKey = 'pending_service_orders';

  // Save pending order to local storage
  Future<void> savePendingOrder(Map<String, dynamic> orderData) async {
    List<Map<String, dynamic>> pendingOrders = getPendingOrders();
    pendingOrders.add(orderData);
    await box.write(pendingOrdersKey, jsonEncode(pendingOrders));
  }

  // Get all pending orders
  List<Map<String, dynamic>> getPendingOrders() {
    String? ordersJson = box.read(pendingOrdersKey);
    if (ordersJson == null) return [];
    List<dynamic> decodedList = jsonDecode(ordersJson);
    return List<Map<String, dynamic>>.from(decodedList);
  }

  // Remove a specific order after successful sync
  Future<void> removePendingOrder(int index) async {
    List<Map<String, dynamic>> pendingOrders = getPendingOrders();
    pendingOrders.removeAt(index);
    await box.write(pendingOrdersKey, jsonEncode(pendingOrders));
  }

  // Clear all pending orders
  Future<void> clearPendingOrders() async {
    await box.remove(pendingOrdersKey);
  }

  // Check if there are any pending orders
  bool hasPendingOrders() {
    return getPendingOrders().isNotEmpty;
  }

    // Add method to get offline profile
  Map<String, dynamic>? getOfflineProfile() {
    return box.read('offline_profile');
  }

  // Add method to save offline profile
  Future<void> saveOfflineProfile(Map<String, dynamic> profileData) async {
    await box.write('offline_profile', profileData);
  }
}