import 'package:get/get.dart';
import '../controllers/booking_service_controller.dart';
import '../../../data/services/authentication/controllers/authentication_controller.dart';
import '../../../data/services/location_controller.dart';
import '../../maps/controllers/maps_controller.dart';

class ServiceBookingBinding implements Bindings {
  @override
  void dependencies() {
    // Ensure dependencies are registered as singletons
    Get.lazyPut<AuthenticationController>(() => AuthenticationController(),
        fenix: true);
    Get.lazyPut<GetConnectController>(() => GetConnectController(),
        fenix: true);
    Get.lazyPut<MapsController>(() => MapsController(), fenix: true);

    // Register the ServiceBookingController
    Get.lazyPut<ServiceBookingController>(() => ServiceBookingController());
  }
}
