import 'package:get/get.dart';
import '../controllers/bookService_controller.dart';

class BookServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookServiceController>(
      () => BookServiceController(),
    );
  }
}