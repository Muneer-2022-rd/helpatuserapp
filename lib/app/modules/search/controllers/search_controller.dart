import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/data/search_data.dart';
import 'package:helpat/common/Functions/handeldata.dart';
import 'package:helpat/common/Functions/stutsrequest.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';

class SearchController extends GetxController {

  SearchData searchData = SearchData(Get.find());
  StatusRequest searchStatusRequest = StatusRequest.non;
  RefreshController refreshController = RefreshController(initialRefresh:  true);
  int currentPage  = 1 ;
  String? nextPage = null ;

  final heroTag = "".obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxList<String?> selectedCategories = <String>[].obs;
  TextEditingController? textEditingController;

  List? eServices = [];
  late EServiceRepository _eServiceRepository;
  late CategoryRepository _categoryRepository;
  SearchController() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    textEditingController = new TextEditingController();
  }

  @override
  void onInit() async {
    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments ?? '';
    super.onReady();
  }

  Future refreshSearch({bool? showMessage}) async {
    await getCategories();
    //await searchEServices();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }


  searchEservice({bool isBannerSearch = false})async
  {
    print("run");
    if(isBannerSearch){
      searchStatusRequest = StatusRequest.loading ;
      print("refresh");
      refreshController.resetNoData();
      currentPage = 1;
      update();
    }else{
      if(nextPage == null || nextPage!.isEmpty){
        refreshController.loadNoData();
      }
    }
    var response = await searchData.searchEserviceWithCategories(selectedCategories.join(","),textEditingController!.text,currentPage);
    searchStatusRequest = handlingData(response);
    if (StatusRequest.success == searchStatusRequest) {
      if (response["success"] == true) {
        print("true");
        if(isBannerSearch){
          eServices = response['data']['data'];
        }else{
          eServices!.addAll(response['data']['data']);
        }
        currentPage = currentPage + 1 ;
        nextPage = response["data"]["next_page_url"];
        print("NextPage Url From Api ${response["data"]["next_page_url"]}");
        print("NextPage Url From App ${nextPage}");
        update();
        return true ;
      } else {
        searchStatusRequest = StatusRequest.noData;
        update();
        print("false to search");
        return false ;
      }
    }
  }




  Future searchEServices({String? keywords}) async {
    try {
      if (selectedCategories.isEmpty) {
        eServices!.assignAll(await (_eServiceRepository.search(textEditingController!.text,categories.map((element) => element.id).toList()) as FutureOr<Iterable<dynamic>>));
      } else {
        eServices!.assignAll(await (_eServiceRepository.search(textEditingController!.text,selectedCategories.toList()) as FutureOr<Iterable<dynamic>>));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }





  Future getCategories() async {
    try {
      categories.assignAll(await (_categoryRepository.getAllParents() as FutureOr<Iterable<Category>>));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  void toggleCategory(bool value, Category category) {
    if (value) {
      selectedCategories.add(category.id);
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
    }
  }
  onChangeSearch(String value){
    if(value.length == 0){
      eServices!.clear() ;
      eServices = [];
      refreshController.refreshToIdle();
      update();
    }
  }

}
