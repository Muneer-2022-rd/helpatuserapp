import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpat/app/modules/settings/controllers/address_controller.dart';


class AddressPickerView extends GetView<AddressController> {
  AddressPickerView();

  @override
  Widget build(BuildContext context){
    Get.put(AddressController());
    return Scaffold(
      body: GetBuilder<AddressController>(
        builder: (controller){
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: double.infinity,
                child: controller.kGoogle == null ? Center(
                  child: CircularProgressIndicator(),
                    ) :  GoogleMap(
                  initialCameraPosition: controller.kGoogle,
                  myLocationEnabled: true,
                  markers: {
                    Marker(
                      markerId: MarkerId("1"),
                      position: LatLng(25.276987, 55.296249),
                      infoWindow: InfoWindow(
                          title: "Locate Your company"),
                      onDragEnd: (LatLng t) {
                        controller.onDragMarker(t);
                      },
                      draggable: true,
                    ),
                  },
                ),
              ),
            ],
          );
        }
      ),
    );

  }
}

class SearchLocation extends StatelessWidget {
  const SearchLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: "Enter Your Location",
        suffixIcon: Icon(Icons.search),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}


/* PlacePicker(
      apiKey: "AIzaSyCNiQYsSAw-c1iOaEt5zF8ym2X8xWWc0iI",
      initialPosition: Get.find<SettingsService>().address.value.getLatLng(),
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePlaceDetailSearch: true,
      forceSearchOnZoomChanged: true,
      selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
        if (isSearchBarFocused) {
          return SizedBox();
        }
        Address _address = Address(address: selectedPlace?.formattedAddress ?? '');
        return FloatingCard(
          height: 300,
          elevation: 0,
          bottomPosition: 0.0,
          leftPosition: 0.0,
          rightPosition: 0.0,
          color: Colors.transparent,
          child: state == SearchingState.Searching
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      labelText: "Description".tr,
                      hintText: "My Home".tr,
                      initialValue: _address.description,
                      onChanged: (input) => _address.description = input,
                      iconData: Icons.description_outlined,
                      isFirst: true,
                      isLast: false,
                    ),
                    TextFieldWidget(
                      labelText: "Full Address".tr,
                      hintText: "123 Street, City 136, State, Country".tr,
                      initialValue: _address.address,
                      onChanged: (input) => _address.address = input,
                      iconData: Icons.place_outlined,
                      isFirst: false,
                      isLast: true,
                    ),
                    BlockButtonWidget(
                      onPressed: () async {
                        Get.find<SettingsService>().address.update((val) {
                          val.description = _address.description;
                          val.address = _address.address;
                          val.latitude = selectedPlace.geometry.location.lat;
                          val.longitude = selectedPlace.geometry.location.lng;
                          val.userId = Get.find<AuthService>().user.value.id;
                        });
                        if (Get.isRegistered<BookEServiceController>()) {
                          await Get.find<BookEServiceController>().getAddresses();
                        }
                        if (Get.isRegistered<RootController>()) {
                          await Get.find<RootController>().refreshPage(0);
                        }
                        Get.back();
                      },
                      color: Get.theme.colorScheme.secondary,
                      text: Text(
                        "Pick Here".tr,
                        style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
                      ),
                    ).paddingSymmetric(horizontal: 20),
                    SizedBox(height: 10),
                  ],
                ),
        );
      },
    ); */
