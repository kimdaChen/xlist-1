import 'package:get/get.dart';
import 'package:xlist/storages/preferences_storage.dart';

class UserStorage extends GetxService {
  final id = ''.obs;
  final token = ''.obs;
  final serverId = 0.obs;
  final serverUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    id.value = Get.find<PreferencesStorage>().id.val ?? '';
    token.value = Get.find<PreferencesStorage>().token.val ?? '';
    serverId.value = Get.find<PreferencesStorage>().serverId.val ?? 0;
    serverUrl.value = Get.find<PreferencesStorage>().serverUrl.val ?? '';
  }

  @override
  void onClose() {
    id.close();
    token.close();
    serverId.close();
    serverUrl.close();
    super.onClose();
  }
}
