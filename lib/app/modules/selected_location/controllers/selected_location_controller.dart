import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../service/controllers/service_controller.dart';

class SelectedLocationController extends GetxController {
  final String selectedLocation;
  final ServiceController _serviceController = Get.find<ServiceController>();

  SelectedLocationController(this.selectedLocation);

  RxList<Service> serviceList = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    serviceList.value = _serviceController.services;
  }
}