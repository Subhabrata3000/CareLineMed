import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import '../Api/data_store.dart';
import '../model_doctor/store_list_model.dart';

class StoreListController extends GetxController implements GetxService {

  StoreListModel? storeListModel;

  double distanceInMeters = 0;
  double distanceInKm = 0;
  bool isLoading = false;

  storeListApi({required String serviceId}) async {
    Map body = {
      "uid": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "category_id": serviceId,
      "lat": lat.toString(),
      "lon": long.toString()
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.storeList), body: jsonEncode(body), headers: userHeader);

    debugPrint("''''''''''' storeList Api url '''''''''''' ${Config.baseUrlDoctor + Config.storeList}");
    debugPrint("''''''''''' storeList Api body ''''''''''' $body");
    debugPrint("''''''''' storeList Api respons '''''''''' ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        storeListModel = storeListModelFromJson(response.body);
        if (storeListModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: storeListModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."
      );
    }
  }

  double calculateDistance({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng); // in meters
  }
}
