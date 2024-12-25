// File 12: /lib/app/modules/selected_location/controllers/selected_location_controller.dart
import 'package:get/get.dart';
import '../../../data/models/service_model.dart';
import '../../service/controllers/service_controller.dart';

class SelectedLocationController extends GetxController {
  final String selectedLocation;
  final ServiceController _serviceController = Get.find<ServiceController>();
  RxList<Service> serviceList = <Service>[].obs;

  SelectedLocationController(this.selectedLocation);

  @override
  void onInit() {
    super.onInit();
    filterServicesByLocation(selectedLocation);
  }

  void filterServicesByLocation(String location) {
    serviceList.value = _serviceController.filterServicesByLocation(location);
  }
}
