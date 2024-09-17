import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/media_model.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'settings_service.dart';

class AuthService extends GetxService {
  final Rx<User> user = User().obs;
  late GetStorage _box;

  late UserRepository _usersRepo;

  AuthService() {
    _usersRepo = new UserRepository();
    _box = new GetStorage();
  }

  User setUserData(
      {String? id,
      String? name,
      String? img,
      String? email,
      String? password,
      Media? avatar,
      String? apiToken,
      String? deviceToken,
      String? phoneNumber,
      bool? verifiedPhone,
      String? verificationId,
      String? address,
      String? bio,
      bool? auth,
      bool? isSocial}) {
    return User(
        name: name ?? Get.find<AuthService>().user.value.name,
        email: email ?? Get.find<AuthService>().user.value.email,
        verifiedPhone:
            verifiedPhone ?? Get.find<AuthService>().user.value.verifiedPhone,
        password: password ?? Get.find<AuthService>().user.value.password,
        address: address ?? Get.find<AuthService>().user.value.address,
        apiToken: apiToken ?? Get.find<AuthService>().user.value.apiToken,
        avatar: avatar ?? Get.find<AuthService>().user.value.avatar,
        bio: bio ?? Get.find<AuthService>().user.value.bio,
        deviceToken:
            deviceToken ?? Get.find<AuthService>().user.value.deviceToken,
        phoneNumber:
            phoneNumber ?? Get.find<AuthService>().user.value.phoneNumber,
        verificationId: verificationId ??
            Get.find<AuthService>().user.value.verificationId);
  }

  Future<AuthService> init() async {
    user.listen((User _user) {
      if (Get.isRegistered<SettingsService>()) {
        Get.find<SettingsService>().address.value!.userId = _user.id;
      }
      _box.write('current_user', _user.toJson());
    });
    await getCurrentUser();
    return this;
  }

  Future getCurrentUser() async {
    if (user.value.auth == null && _box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      user.value.auth = true;
    } else {
      user.value.auth = false;
    }
  }

  Future removeCurrentUser() async {
    user.value = new User();
    await _usersRepo.signOut();
    await _box.remove('current_user');
  }

  bool get isAuth => user.value.auth ?? false;

  String? get apiToken => (user.value.auth ?? false) ? user.value.apiToken : '';
}
