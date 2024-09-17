/*
 * Copyright (c) 2020 .
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../../../models/custom_page_model.dart';
import '../../../models/menue.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../account/views/account_view.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/views/bookings_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final RxList<CustomPage> customPages = <CustomPage>[].obs;
  late NotificationRepository _notificationRepository;
  late CustomPageRepository _customPageRepository;

  bool hideNavigationBar = false;

  late AnimationController animationController;

  late Animation<double> animation;


  Menu selectedBottonNav = bottomNavItems.first;
  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu, int index) {
    if (Get.find<RootController>().selectedBottonNav != menu) {
      currentIndex.value = index;
      Get.find<RootController>().selectedBottonNav = menu;
      update();
    }
  }

  startHideNavigationBar() {
    hideNavigationBar = true;
    animationController.forward();
    update();
  }

  endHideNavigationBar() {
    hideNavigationBar = false;
    animationController.reverse();
    update();
  }

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await getCustomPages();
  }

  List<Widget> pages = [
    Home2View(),
    BookingsView(),
    MessagesView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  Future<void> changePageInRoot(int _index) async {
    Get.log(currentIndex.value.toString());
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    } else {
      currentIndex.value = _index;
      updateSelectedBtmNav(bottomNavItems[_index], _index);
      update();
      await refreshPage(_index);
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    Get.log("index : ${_index}");
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = _index;
    updateSelectedBtmNav(bottomNavItems[_index], _index);
    await refreshPage(_index);
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
    update();
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          await Get.find<BookingsController>().refreshBookings();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
    update();
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
