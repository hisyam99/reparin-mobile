import 'package:get/get.dart';
import '../controllers/add_service_controller.dart';

class AddServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddServiceController>(
      () => AddServiceController(),
    );
  }
}
