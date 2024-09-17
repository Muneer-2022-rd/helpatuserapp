import 'package:get/get.dart';
import 'package:helpat/app/modules/auth/controllers/auth_controller.dart';
import 'package:helpat/common/class/curd.dart';

class MyBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(Crud());
    Get.lazyPut(() => AuthController());
  }

}