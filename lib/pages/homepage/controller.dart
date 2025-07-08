import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xlist/models/object.dart';
import 'package:xlist/storages/user_storage.dart';
import 'package:xlist/repositorys/object_repository.dart';
import 'package:easy_refresh/easy_refresh.dart';

class HomepageController extends GetxController {
  final objects = Rx<List<ObjectModel>>([]);
  final isFirstLoading = true.obs;
  final serverId = 0.obs;
  final layoutType = 'grid'.obs;
  final isShowPreview = true.obs;
  final userInfo = Rx<dynamic>(null);

  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    serverId.value = Get.find<UserStorage>().serverId.val;
    getObjectList();
  }

  Future<void> getObjectList() async {
    if (serverId.value == 0) {
      isFirstLoading.value = false;
      return;
    }
    try {
      final repository = ObjectRepository(serverId.value);
      final result = await repository.getObjects('/');
      objects.value = result;
    } catch (e) {
      print(e);
    } finally {
      isFirstLoading.value = false;
    }
  }

  Future<void> resetUserToken(dynamic server) async {
    // Implement resetUserToken logic here
  }
}
