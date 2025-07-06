import 'package:get/get.dart';
import 'package:xlist/pages/test/controller.dart';

class TestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestController>(() => TestController());
  }
}
