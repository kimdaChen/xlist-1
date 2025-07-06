import 'dart:io';
import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'package:xlist/services/browser_service.dart';
import 'package:xlist/services/database_service.dart';
import 'package:xlist/services/device_info_service.dart';
import 'package:xlist/services/dio_service.dart';
import 'package:xlist/services/download_service.dart';
import 'package:xlist/services/player_notification_service.dart';
import 'package:xlist/storages/common_storage.dart';
import 'package:xlist/storages/preferences_storage.dart';
import 'package:xlist/storages/user_storage.dart'; // 添加 UserStorage 导入
import 'package:xlist/constants/common.dart';
import 'package:xlist/models/user.dart'; // 添加 UserModel 和 UserRole 导入
import 'package:xlist/repositorys/user_repository.dart'; // 添加 UserRepository 导入

// 全局配置
class Global {
  static bool get isRelease => kReleaseMode;
  static bool get isProfile => kProfileMode;
  static bool get isDebug => kDebugMode;

  // 运行初始化
  static Future<void> init() async {
    // Init FlutterBinding
    WidgetsFlutterBinding.ensureInitialized();

    // HttpOverrides
    HttpOverrides.global = XlistHttpOverrides();

    // GetStorage
    await GetStorage.init();

    // Storage
    await Get.put(CommonStorage());
    await Get.putAsync(() => PreferencesStorage().init());
    await Get.put(UserStorage()); // 初始化 UserStorage

    // Init Getx Service
    await Get.put(BrowserService());
    await Get.putAsync(() => DioService().init());
    await Get.putAsync(() => DatabaseService().init()); // 取消注释
    // await Get.putAsync(() => DownloadService().init()); // 暂时注释
    // await Get.putAsync(() => DeviceInfoService().init()); // 暂时注释
    // await Get.putAsync(() => PlayerNotificationService().init()); // 暂时注释

    // 读取设备第一次打开
    final isFirstOpen = Get.find<PreferencesStorage>().isFirstOpen;
    if (isFirstOpen.val == true) {
      isFirstOpen.val = false;

      // IOS 请求联网弹窗
      try {
        // if (GetPlatform.isIOS) DioService.to.dio.get('https://xlist.site'); // 暂时注释
      } catch (e) {}
    }

    // Theme
    Get.changeThemeMode(ThemeModeMap[Get.find<CommonStorage>().themeMode.val]!);

    // android 状态栏为透明的沉浸
    if (GetPlatform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}

class XlistHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // allowLegacyUnsafeRenegotiation
    final SecurityContext sc = SecurityContext();
    sc.allowLegacyUnsafeRenegotiation = true;

    return super.createHttpClient(sc)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
