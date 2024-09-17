import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../services/auth_service.dart';

class FirebaseProvider extends GetxService {
  fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;

  Future<FirebaseProvider> init() async {
    return this;
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      print('sign in w Apple');
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (result.identityToken != null) {
        print(result);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      fba.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return await signUpWithEmailAndPassword(email, password);
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    fba.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> verifyPhone(String smsCode) async {
    print(Get.find<AuthService>().user.value.verificationId);
      final fba.AuthCredential credential = fba.PhoneAuthProvider.credential(verificationId: Get.find<AuthService>().user.value.verificationId!, smsCode: smsCode);
      await fba.FirebaseAuth.instance.signInWithCredential(credential).then((value){
        Get.find<AuthService>().user.value.verifiedPhone = true;
      }).catchError((error){
        Get.find<AuthService>().user.value.verifiedPhone = false;
        throw Exception(error.message.toString());
      });
  }

  Future<void> sendCodeToPhone() async {
    print("Number Phone : ${Get.find<AuthService>().user.value.phoneNumber!}");
    Get.find<AuthService>().user.value.verificationId = '';
    final fba.PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {};
    final fba.PhoneCodeSent smsCodeSent = (String verId, [int? forceCodeResent]) {
      Get.find<AuthService>().user.value.verificationId = verId;
    };
    final fba.PhoneVerificationCompleted _verifiedSuccess = (fba.AuthCredential auth) async {};
    final fba.PhoneVerificationFailed _verifyFailed = (fba.FirebaseAuthException e) {
      throw Exception(e.message);
    };
    await _auth.verifyPhoneNumber(
      phoneNumber: Get.find<AuthService>().user.value.phoneNumber!,
      timeout: const Duration(seconds: 30),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();

      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> deleteUser() async {
    try {
      await _auth.currentUser?.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
