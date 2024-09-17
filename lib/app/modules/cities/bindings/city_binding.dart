import 'package:get/get.dart';


import '../controllers/city_controller.dart';

class CityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CityController>(
      () => CityController(),
    );
    Get.lazyPut<CityController>(
          () => CityController(),
    );
  }
}
