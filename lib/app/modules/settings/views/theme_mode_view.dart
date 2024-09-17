import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/models/menue.dart';
import 'package:helpat/app/modules/root/controllers/root_controller.dart';
import 'package:helpat/app/routes/app_routes.dart';

import '../../../../common/ui.dart';
import '../controllers/theme_mode_controller.dart';

class ThemeModeView extends GetView<ThemeModeController> {
  final bool hideAppBar;

  ThemeModeView({this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Get.offNamed(Routes.ROOT);
        Get.find<RootController>().updateSelectedBtmNav(bottomNavItems[0], 0);
        return true ;
      },
      child: Scaffold(
          appBar: hideAppBar
              ? PreferredSize(
            preferredSize: Size(0, 0),
            child: AppBar(
              title: Text(
                "".tr,
                style: context.textTheme.headline6,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              elevation: 0,
            ),
          )
              : AppBar(
                  title: Text(
                    "Theme Mode".tr,
                    style: context.textTheme.headline6,
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                    onPressed: (){
                      Get.offNamed(Routes.ROOT);
                      Get.find<RootController>().updateSelectedBtmNav(bottomNavItems[0], 0);
                    },
                  ),
                  elevation: 0,
                ),
          body: ListView(
            primary: true,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: Ui.getBoxDecoration(),
                child: Column(
                  children: [
                    RadioListTile(
                      value: ThemeMode.light,
                      groupValue: controller.selectedThemeMode.value,
                      onChanged: (dynamic value) {
                        controller.changeThemeMode(value);
                      },
                      title: Text("Light Theme".tr, style: Get.textTheme.bodyText2),
                    ),
                    RadioListTile(
                      value: ThemeMode.dark,
                      groupValue: controller.selectedThemeMode.value,
                      onChanged: (dynamic value) {
                        controller.changeThemeMode(value);
                      },
                      title: Text("Dark Theme".tr, style: Get.textTheme.bodyText2),
                    ),
                    RadioListTile(
                      value: ThemeMode.system,
                      groupValue: controller.selectedThemeMode.value,
                      onChanged: (dynamic value) {
                        controller.changeThemeMode(value);
                      },
                      title: Text("System Theme".tr, style: Get.textTheme.bodyText2),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
