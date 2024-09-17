import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  late LaravelApiClient _laravelApiClient;
  late FirebaseProvider _firebaseProvider;

  UserRepository() {}

  Future<User> login(User user, String password) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user, password);
  }

  Future<bool> signUpWithApple(User user) async {
    LaravelApiClient _laravelApiClient2 = new LaravelApiClient();
    if (_laravelApiClient2.registerApple(user) == true) {
      // this.login(user);
      return true;
    } else {
      // this.login(user);
      return false;
    }
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithApple();
  }

  Future<User> loginSocial(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.loginSocial(user);
  }

  Future<User> get(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updateUser(user);
  }

  Future<bool> sendResetLinkEmail(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() {
    return this.get(Get.find<AuthService>().user.value);
  }

Future<bool> delete(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.deleteUser(user);
  }
  Future<User> register(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<void> verifyPhone(String smsCode) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.sendCodeToPhone();
  }

  Future signOut() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return await _firebaseProvider.signOut();
  }
}
