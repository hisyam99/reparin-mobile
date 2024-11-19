import 'package:get/get.dart';

import '../controllers/booksuccess_controller.dart';

class BooksuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BooksuccessController>(
      () => BooksuccessController(),
    );
  }
}