import 'package:get/get.dart';
import '../controllers/admin_chat_controller.dart';

class AdminChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminChatController>(
      () => AdminChatController(),
    );
  }
}
