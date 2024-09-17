import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../../../../common/ui.dart';
import '../../../models/city_model.dart';
import '../../../models/favorite_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/city_repository.dart';
import '../../../services/auth_service.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../models/e_service_model.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class CityController extends GetxController {
  final Rx<City?> city = City().obs;
  final RxList<Review> reviews = <Review>[].obs;
  // final tags = <Tag>[].obs;
  final RxList<OptionGroup> optionGroups = <OptionGroup>[].obs;
  final currentSlide = 0.obs;
  final quantity = 1.obs;
  final heroTag = ''.obs;
  final RxList<EService> eServices = <EService>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;

  late CityRepository _cityRepository;
  late EServiceRepository _eServiceRepository;

  ScrollController scrollController = ScrollController();
  CityController() {
    _cityRepository = new CityRepository();
    _eServiceRepository = new EServiceRepository();
  }

  // @override
  // void onInit() async {
  //   var arguments = Get.arguments as Map<String, dynamic>;
  //   city.value = arguments['city_id'] as City;
  //   // heroTag.value = arguments['heroTag'] as String;
  //   await refreshEServices();
  //   super.onInit();
  // }

  Future<void> onInit() async {
    city.value = Get.arguments as City?;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadEServicesOfCity(city.value!.id);
      }
    });
    await refreshEServices();
    super.onInit();
  }
  @override
  void onReady() async {
    await refreshCity();
    super.onReady();
  }

  Future refreshEServices({bool? showMessage}) async {
    print('test id citycontroler');

    // print(city.value.id);
    await loadEServicesOfCity(city.value!.id);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of cities refreshed successfully".tr));
    }
     messageCheck();
  }

  Future loadEServicesOfCity(String? cityId) async {
    try {

      // isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService>? _eServices = [];
      // switch (filter) {
      //   case CategoryFilter.ALL:
          _eServices = await (_eServiceRepository.getAllWithPaginationCities(cityId, page: this.page.value) as FutureOr<List<EService>>);
      //     break;
      //   case CategoryFilter.FEATURED:
      //     _eServices = await _eServiceRepository.getFeatured(categoryId, page: this.page.value);
      //     break;
      //   case CategoryFilter.POPULAR:
      //     _eServices = await _eServiceRepository.getPopular(categoryId, page: this.page.value);
      //     break;
      //   case CategoryFilter.RATING:
      //     _eServices = await _eServiceRepository.getMostRated(categoryId, page: this.page.value);
      //     break;
      //   case CategoryFilter.AVAILABILITY:
      //     _eServices = await _eServiceRepository.getAvailable(categoryId, page: this.page.value);
      //     break;
      //   default:
      //     _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
      // }
      if (_eServices.isNotEmpty) {
        this.eServices.addAll(_eServices);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void messageCheck(){
    if(this.isDone==true ){
      isLoading.value = false;
      if(eServices.isEmpty )
        Get.showSnackbar(Ui.SuccessSnackBar(message: "No Data Found".tr));

    }
    isLoading.value = false;
  }
  Future refreshCity({bool showMessage = false}) async {
    await getCity();


    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: city.value!.name! + " " + "page refreshed successfully".tr));
    }
  }

  Future getCity() async {
    try {
      city.value = await _cityRepository.get(city.value!.id);
    } catch (e) {
      // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }



}
