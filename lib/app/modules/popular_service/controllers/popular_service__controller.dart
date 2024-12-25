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
  }
}