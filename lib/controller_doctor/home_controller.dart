// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/home_model.dart';

class HomeController extends GetxController implements GetxService {

  HomeModel? homeModel;
  bool isLoading = false;


  String currentLat = "0.0";
  String currentLong = "0.0";

  List appbarIcon = ["assets/chat-text.svg", "assets/Notification.svg"];

  Future homeApiDoctor({required String lat, required String lon}) async{


    if(lat.isNotEmpty && lat != "null") currentLat = lat;
    if(lon.isNotEmpty && lon != "null") currentLong = lon;


    Map body = {
      "id": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "lat": currentLat,
      "lon": currentLong
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    debugPrint("============== SENDING REAL LOCATION ============== $body");

    try {
      var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.homeApi), body: jsonEncode(body), headers: userHeader);

      debugPrint("============ Home Api response ============ ${response.body}");

      if(response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if(data['Result'] == true){

          try {
            homeModel = homeModelFromJson(response.body);
          } catch(e) {
            debugPrint("Error parsing Home Model: $e");
          }

          if(homeModel != null && homeModel!.result == true){

            if(data["general_currency"] != null) {
              save("currency", data["general_currency"]["site_currency"]);
              save("agoraVcKey", data["general_currency"]["agora_app_id"]);
              save("OneSignalKey", data["general_currency"]["one_app_id"]);
              save("GoogleMapKey", data["general_currency"]["google_map_key"]);
            }

            isLoading = true;
            update();
          } else {
            isLoading = true;
            update();
          }
        } else {
          isLoading = true;
          update();
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        isLoading = true;
        update();
        Fluttertoast.showToast(msg: "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("API Error: $e");
      isLoading = true;
      update();
    }
  }
}