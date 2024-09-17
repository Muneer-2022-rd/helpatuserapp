import 'package:get/get.dart';

import '../models/city_model.dart';
import '../providers/laravel_provider.dart';

class CityRepository {
  late LaravelApiClient _laravelApiClient;

  CityRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<City>> getAll() {
    return _laravelApiClient.getAllCities();
  }
  Future<City> get(String? id) {
    return _laravelApiClient.getCity(id);
  }
  // Future<List<Category>> getAllParents() {
  //   return _laravelApiClient.getAllParentCategories();
  // }
  //
  // Future<List<Category>> getAllWithSubCategories() {
  //   return _laravelApiClient.getAllWithSubCategories();
  // }
  //
  // Future<List<Category>> getSubCategories(String categoryId) {
  //   return _laravelApiClient.getSubCategories(categoryId);
  // }
  //
  // Future<List<Category>> getFeatured() {
  //   return _laravelApiClient.getFeaturedCategories();
  // }
}
