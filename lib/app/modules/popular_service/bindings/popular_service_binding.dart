import 'package:get/get.dart';
import '../controllers/popular_service__controller.dart';
import '../../service/controllers/service_controller.dart';

class PopularServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PopularServiceController>(
      () => PopularServiceController(),
    );
    Get.lazyPut<ServiceController>(
      () => ServiceController(),
    );
  }
}