import 'package:get/get.dart';
import '../controllers/service_provider_controller.dart';

class ServiceProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderController>(() => ServiceProviderController());
  }
}