import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helpat/app/models/menue.dart';
import 'package:helpat/app/modules/root/controllers/root_controller.dart';
import 'package:helpat/app/routes/app_routes.dart';

import 'ui.dart';

class Helper {
  DateTime? currentBackPressTime;

  static Future<dynamic> getJsonFile(String path) async {
    return rootBundle.loadString(path).then(convert.jsonDecode);
  }

  static Future<dynamic> getFilesInDirectory(String path) async {
    var files = io.Directory(path).listSync();
    print(files);
    // return rootBundle.(path).then(convert.jsonDecode);
  }

  static String toUrl(String path) {
    if (!path.endsWith('/')) {
      path += '/';
    }
    return path;
  }

  static String toApiUrl(String path) {
    path = toUrl(path);
    if (!path.endsWith('/')) {
      path += '/';
    }
    return path;
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Get.showSnackbar(Ui.defaultSnackBar(message: "Tap again to leave!".tr));
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  Future<bool> onWillpop(){
    Get.offNamed(Routes.ROOT);
    Get.find<RootController>().updateSelectedBtmNav(bottomNavItems[0], 0);
    return Future.value(true);
  }
}
