// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carelinemed/utils/custom_colors.dart';

import '../../Api/config.dart';
import '../../controller/add_address_controller.dart';
import '../../model/font_family_model.dart';

class DeliveryAddress1 extends StatefulWidget {
  const DeliveryAddress1({super.key});

  @override
  State<DeliveryAddress1> createState() => _DeliveryAddress1State();
}

class _DeliveryAddress1State extends State<DeliveryAddress1> {
  TextEditingController searchLocation = TextEditingController();

  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  var newlatlang;
  String location = "Search for your delivery address".tr;

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  AddAddressController addAddressController = Get.put(AddAddressController());
  String pincode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
          color: WhiteColor,
        ),
        title: Text(
          "Add Your delivery address".tr,
          maxLines: 1,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: WhiteColor,
            fontSize: 17,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          Container(
            height: 50,
            width: 40,
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(
                text: '1',
                style: TextStyle(
                  color: WhiteColor,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 17,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: '/3',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyMedium,
                      color: greyColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleMapKey,
                  mode: Mode.overlay,
                  types: [],
                  resultTextStyle: TextStyle(
                    fontFamily: FontFamily.gilroyMedium,
                    color: BlackColor,
                  ),
                  strictbounds: false,
                  backArrowIcon: Icon(Icons.arrow_back),
                  components: [Component(Component.country, 'In')],
                  onError: (err) {
                    debugPrint("--------- $err");
                  },
                );

                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                    addAddressController.address = place.description.toString();
                  });
                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(
                    apiKey: googleMapKey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  addAddressController.getCurrentLatAndLong(lat, lang);
                  newlatlang = LatLng(lat, lang);
                  mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: newlatlang, zoom: 17),
                    ),
                  );
                  setState(() {});
                }
               },
              child: Container(
                height: 50,
                width: Get.size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/Search.png",
                        height: 20,
                        width: 20,
                        color: Color(0xFF636268),
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyMedium,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () async {
                LocationPermission permission;
                permission = await Geolocator.checkPermission();
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.denied) {}
                var currentLocation = await locateUser();
                debugPrint('location: ${currentLocation.latitude}');
                addAddressController.getCurrentLatAndLong(currentLocation.latitude, currentLocation.longitude);
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/location-pin_filled.svg",
                    height: 25,
                    width: 25,
                    color: BlackColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Get current location with GPS".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      color: BlackColor,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
