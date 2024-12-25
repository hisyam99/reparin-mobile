// File 5: /lib/app/modules/selected_location/bindings/selected_location_binding.dart
import 'package:get/get.dart';
import '../controllers/selected_location_controller.dart';
import '../../service/controllers/service_controller.dart';

class SelectedLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectedLocationController>(
      () => SelectedLocationController(Get.arguments as String),
    );
    Get.lazyPut<ServiceController>(
      () => ServiceController(),
    );
  }
}
