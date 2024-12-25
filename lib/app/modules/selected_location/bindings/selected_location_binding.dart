import 'package:get/get.dart';
import '../controllers/selected_location_controller.dart';
import '../../service/controllers/service_controller.dart';

class SelectedLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectedLocationController>(
      () => SelectedLocationController(Get.arguments['location']),
    );
    Get.lazyPut<ServiceController>(
      () => ServiceController(),
    );
  }
}
