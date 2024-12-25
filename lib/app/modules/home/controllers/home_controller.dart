import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/address.dart';
import '../../../data/models/service_model.dart';
import '../../service/controllers/service_controller.dart';

class HomeController extends GetxController {
  final ServiceController _serviceController = Get.put(ServiceController());

  Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxString addressDetails = "Surabaya".obs;
  final RxBool loading = false.obs;

  // Filtered services list
  final RxList<Service> filteredServices = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initially, filtered services is the same as all services
    filteredServices.value = _serviceController.services;
  }

  Future<void> getCurrentLocation() async {
    loading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location service not enabled');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever');
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentPosition.value = position;
      await fetchAddress(position.latitude, position.longitude);
      loading.value = false;
    } catch (e) {
      loading.value = false;
      addressDetails.value = 'Failed to get address';
    }
  }

  Future<void> fetchAddress(double lat, double lon) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final welcome = Welcome.fromJson(data);
        final address = welcome.address;
        addressDetails.value =
            "${address.village ?? address.city ?? address.county}, ${address.state}, ${address.country}";
      } else {
        throw Exception('Failed to fetch address');
      }
    } catch (e) {
      addressDetails.value = 'Failed to fetch address';
    }
  }

  void filterServicesByLocation(String query) {
    filteredServices.value = _serviceController.filterServicesByLocation(query).obs;
  }
}