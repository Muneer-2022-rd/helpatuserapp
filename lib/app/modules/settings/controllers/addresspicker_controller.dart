import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpat/app/modules/global_widgets/text_field_widget.dart';

import '../../../models/address_model.dart';


class AddressPickerController extends GetxController {
  // final addresses = <Address>[].obs;
  // String currentAddress;
  // // Position currentPosition;
  // Completer<GoogleMapController> controllerGoogleMap = Completer();
  //
  // TextEditingController descController= TextEditingController();
  // TextEditingController addressController = TextEditingController();
  //
  //
  // @override
  // void onInit() async {
  //   await _getCurrentPosition();
  //   super.onInit();
  // }
  //
  //
  //
  // Future<bool> handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Get.back();
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       Get.back();
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     Get.back();
  //     return false;
  //   }
  //   update();
  //   return true;
  // }
  //
  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position)async {
  //     currentPosition = position;
  //     update();
  //    await getAddressFromLatLng(position);
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }
  //
  // Future<void> getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //       position.latitude, position.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //       currentAddress = '${place.street},${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}' ;
  //       update();
  //       addressController.text = currentAddress ;
  //     print("Current Address :  $currentAddress");
  //     print("Current Psation :  $currentPosition");
  //       update();
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }
  //
  // onDragMarker(LatLng t) {
  //   print("latlang maker : $t");
  //   currentPosition = Position(latitude: t.latitude , longitude: t.longitude);
  //   update();
  //   getAddressFromLatLng(currentPosition).then((value){
  //     print("Current Address :  $currentAddress");
  //     print("current Psation : ${t.longitude}  , ${t.latitude}");
  //     openBottomSheet() ;
  //   }).catchError((error){print(error.toString());});
  //   update();
  // }
  //
  //
  // void openBottomSheet() {
  //   Get.bottomSheet(
  //     Form(
  //       child: Column(
  //         children: [
  //           const SizedBox(height: 20),
  //           TextFieldWidget(
  //             labelText: "Description".tr,
  //             controller:descController ,
  //             hintText: "My Home".tr,
  //             // onChanged: (input) => _address.description = input,
  //             iconData: Icons.description_outlined,
  //             isFirst: true,
  //             isLast: false,
  //           ),
  //           TextFieldWidget(
  //             controller: addressController,
  //             labelText: "Full Address".tr,
  //             hintText: "123 Street, City 136, State, Country".tr,
  //             // initialValue: _address.address,
  //             // onChanged: (input) => _address.address = input,
  //             iconData: Icons.place_outlined,
  //             isFirst: false,
  //             isLast: true,
  //           ),
  //           OutlinedButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       ),
  //     ),
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //   );
  // }

}



