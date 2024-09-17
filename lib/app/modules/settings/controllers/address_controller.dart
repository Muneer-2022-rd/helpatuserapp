import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpat/app/modules/book_e_service/controllers/book_e_service_controller.dart';
import 'package:helpat/app/modules/global_widgets/text_field_widget.dart';
import 'package:helpat/app/modules/root/controllers/root_controller.dart';
import 'package:helpat/app/services/auth_service.dart';
import 'package:helpat/app/services/settings_service.dart';
import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../repositories/setting_repository.dart';

class AddressController extends GetxController {
  final loading = false.obs;

  late SettingRepository _settingRepository;
  final RxList<Address> addresses = <Address>[].obs;
  CameraPosition kGoogle =
      CameraPosition(target: LatLng(25.2048, 55.2708), zoom: 10);
  LatLng? latLng;

  GlobalKey<FormState> keyFormAddress = GlobalKey<FormState>();

  late TextEditingController latlangController;

  late TextEditingController addressController;

  late TextEditingController descController;

  AddressController() {
    _settingRepository = new SettingRepository();
  }

  @override
  void onInit() async {
    latlangController = TextEditingController();
    addressController = TextEditingController();
    descController = TextEditingController();
    await refreshAddresses();
    super.onInit();
  }

  Future refreshAddresses({bool? showMessage}) async {
    await getAddresses();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of addresses refreshed successfully".tr));
    }
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await (_settingRepository.getAddresses()));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future saveAddress() async {
    if (keyFormAddress.currentState!.validate()) {
      loading.value = true;
      update();
      Get.log(
          "latlng save address : ${latLng!.latitude.toString()} , ${latLng!.longitude.toString()}");
      Get.log("address : ${addressController.text}");
      Get.log("description : ${descController.text}");
      Get.log(latLng!.latitude.toString());
      Get.find<SettingsService>().address.update((val) {
        val!.description = descController.text;
        val.address = addressController.text;
        val.latitude = latLng!.latitude;
        val.longitude = latLng!.longitude;
        val.userId = Get.find<AuthService>().user.value.id;
      });

      Get.log(Get.find<SettingsService>().address.toString());
      if (Get.isRegistered<BookEServiceController>()) {
        await Get.find<BookEServiceController>()
            .getAddresses()
            .then((value) {});
      }
      if (Get.isRegistered<RootController>()) {
        await Get.find<RootController>().refreshPage(0).then((value) {});
      }
      loading.value = false;
      update();
      Get.back();
      Get.back();
    }
  }

  void openBottomSheet() {
    Get.log(
        "latlng save address : ${latLng!.latitude.toString()} , ${latLng!.longitude.toString()}");
    Get.log("address : ${addressController.text}");
    Get.log("description : ${descController.text}");
    Get.log(latLng!.latitude.toString());
    Get.bottomSheet(
      Form(
        key: keyFormAddress,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            TextFieldWidget(
              controller: latlangController,
              labelText: "LatLong".tr,
              hintText: "35.5555,2.5555".tr,
              // initialValue: _address.address,
              // onChanged: (input) => _address.address = input,
              iconData: Icons.place_outlined,
              readOnly: true,
              isFirst: false,
              isLast: false,
            ),
            TextFieldWidget(
              controller: addressController,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter Full Address';
                }
                // else if (input.isAddress) {
                //   return 'Please enter "Country,City,Region,Street Name 123"';
                // }
                return null;
              },

              labelText: "Full Address".tr,
              hintText: "Country , City , Region , Street Name 123".tr,
              // initialValue: _address.address,
              // onChanged: (input) => _address.address = input,
              iconData: Icons.place_outlined,
              isFirst: false,
              isLast: false,
            ),
            TextFieldWidget(
              labelText: "Description *".tr,
              controller: descController,
              hintText: "Enter Description".tr,
              // onChanged: (input) => _address.description = input,
              iconData: Icons.description_outlined,
              isFirst: false,
              isLast: true,
            ),
            GetBuilder<AddressController>(
              builder: (controller) {
                return controller.loading.value == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.saveAddress();
                            },
                            child: const Text('Save Address'),
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enableDrag: true,
    );
  }

  onDragMarker(LatLng t) {
    latLng = t;
    latlangController.text = "${t.latitude} , ${t.longitude}";
    update();
    print(latlangController.text);
    openBottomSheet();
    update();
  }
}

extension FancyNum on String {
  bool get isAddress {
    String pattern = r'[A-Za-z]+,[A-Za-z]+,[A-Za-z]+,[A-Za-z]+\s+[0-9]+';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(this)) {
      return true;
    } else {
      return false;
    }
  }
}
