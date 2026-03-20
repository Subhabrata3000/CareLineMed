// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:get/get.dart';


class SelectLocationController extends GetxController implements GetxService {
  var lat;
  var long;
  var address;
  getCurrentLatAndLong(double latitude, double longitude) {
    lat = latitude;
    long = longitude;
    update();
  }
}