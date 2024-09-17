import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpat/app/providers/firebase_provider.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../root/controllers/root_controller.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState>? loginFormKey;
  GlobalKey<FormState>? registerFormKey;
  GlobalKey<FormState>? forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  late UserRepository _userRepository;
  User user = new User();

  AuthController() {
    _userRepository = UserRepository();
  }

  void appleRegister() async {
    try {
      final firebaseProvider = Get.find<FirebaseProvider>();

      loading.value = true;
      update();

      final result = await firebaseProvider.signInWithApple();

      if (result != null) {
        loading.value = true;
        update();

        currentUser.value.name = result.givenName;
        user.name = result.givenName;
        user.password = result.userIdentifier;
        user.email = result.email;
        user.phoneNumber = result.userIdentifier;
        user.social_id = result.userIdentifier;
            print(user.social_id);
        update();

        _userRepository.signUpWithApple(user).then((value) {
          Get.find<FireBaseMessagingService>()
              .setDeviceToken()
              .then((value) async {
            Timer(Duration(seconds: 3), () async {
              await _userRepository.signInWithApple().then((value) async {
                await _userRepository.loginSocial(user).then((value) {
                  currentUser.value = value;
                  Get.log("user ${value.toString()}");
                  loading.value = false;
                  update();
                  Get.offAllNamed(Routes.ROOT);
                  Get.showSnackbar(Ui.SuccessSnackBar(
                      message: "Logged in as ".tr + "${value.name}"));
                }).catchError((error) {
                  Get.showSnackbar(Ui.ErrorSnackBar(
                      message:
                          'Your Account is suspended contact with admin to unsuspended'
                              .tr));
                  loading.value = false;
                  update();
                });
              });
            });
          }).catchError((error) {
            loading.value = false;
            update();
          });
        }).catchError((error) {
          print(error);
        });
      }
    } catch (e) {
      loading.value = false;
      update();
    }
  }

  void login() async {
    Get.focusScope!.unfocus();
    if (loginFormKey!.currentState!.validate()) {
      loginFormKey!.currentState!.save();
      loading.value = true;
      try {
        //await Get.find<FireBaseMessagingService>().setDeviceToken();
        currentUser.value = await _userRepository.login(
            currentUser.value, currentUser.value.password!);
        // await _userRepository
        //     .signInWithEmailAndPassword(
        //         currentUser.value.email!, currentUser.value.apiToken!)
        //     .then((value) async {
          Get.showSnackbar(
              Ui.SuccessSnackBar(message: "Welcome ${currentUser.value.name}"));
          Get.offNamedUntil(Routes.ROOT, (route) => false)!.then((value) {});
        ;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString().substring(11)));
      } finally {
        loading.value = false;
      }
    }
  }

  void register() async {
    Get.focusScope!.unfocus();
    if (registerFormKey!.currentState!.validate()) {
      registerFormKey!.currentState!.save();
      loading.value = true;
      try {
        await _userRepository.sendCodeToPhone();
        loading.value = false;
        await Get.toNamed(Routes.PHONE_VERIFICATION);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(
          currentUser.value.email!, currentUser.value.apiToken!);
      await Get.find<RootController>().changePage(0);
    } catch (e) {
      Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString().substring(11)));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope!.unfocus();
    if (forgotPasswordFormKey!.currentState!.validate()) {
      forgotPasswordFormKey!.currentState!.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email!));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
}
