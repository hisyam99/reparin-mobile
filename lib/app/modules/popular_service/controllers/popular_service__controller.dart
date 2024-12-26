// File 4: /lib/app/modules/popular_service/controllers/popular_service_controller.dart
import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../service/controllers/service_controller.dart';

class PopularServiceController extends GetxController {
  final ServiceController _serviceController = Get.find<ServiceController>();
  RxList<Service> serviceList = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    serviceList.value = _serviceController.services;
    // Listen to changes in the ServiceController's services list
    ever(_serviceController.services, (newServices) {
      serviceList.value = newServices;
    });
  }

  void toggleBookmark(String serviceId) {
    _serviceController.toggleBookmark(serviceId);
    // The serviceList will be updated automatically through the ever listener
  }
}