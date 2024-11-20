import 'package:get/get.dart';
import '../controllers/booksuccess_controller.dart';
import '../../settings/controllers/settings_controller.dart';

class BooksuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BooksuccessController>(() => BooksuccessController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
