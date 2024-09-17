import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/models/city_model.dart';
import 'package:helpat/app/models/event_model.dart';
import 'package:helpat/app/repositories/city_repository.dart';
import 'package:helpat/app/repositories/event_repository.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  late SliderRepository _sliderRepo;
  late CategoryRepository _categoryRepository;
  late EServiceRepository _eServiceRepository;
  late CityRepository _cityRepository;
  late EventRepository _eventRepository;

  final RxList<Address> addresses = <Address>[].obs;
  final RxList<Slide> slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final RxList<EService> eServices = <EService>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Category> featured = <Category>[].obs;
  final RxList<City> cities = <City>[].obs;
  final RxList<Event> events = <Event>[].obs;


  late ScrollController scrollController;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _cityRepository = new CityRepository();
    _eServiceRepository = new EServiceRepository();
    _eventRepository = new EventRepository();

  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    await getSlider();
    await getCategories();
    await getCities();
    await getEvents();
    await getFeatured();
    await getRecommendedEServices();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Address? get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
//      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }


  Future getCities() async {
    try {
      cities.assignAll(await _cityRepository.getAll());

    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There is a problem loading the page. Please check your internet connection"));
    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
    }
  }

  Future getEvents() async {
    try {
      events.assignAll(await _eventRepository.getAllEvents());
    } catch (e) {
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.assignAll(await _eServiceRepository.getRecommended());
    } catch (e) {
    }
  }

  Future<bool> willPopExitApp() async {
    Get.defaultDialog(
        title: "Alert".tr,
        middleText: "Are you sure to exit ?".tr,
        middleTextStyle: TextStyle(color: Colors.black),
        content: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Are you sure to exit app ?".tr,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              exit(0);
            },
            child: Text("Yes".tr),
          ),
          MaterialButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No".tr),
          ),
        ]);
    return true;
  }

}
