import 'package:get/get.dart';

class TestController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('TestController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    print('TestController ready');
  }

  @override
  void onClose() {
    super.onClose();
    print('TestController closed');
  }
}
