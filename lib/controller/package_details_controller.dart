import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:laundry/Api/config.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/model/packge_detail_model.dart';

class PackageDetailsController extends GetxController implements GetxService {
  String currency = "";
  
  PackgeDetailApiModel? packgeDetailApiModel;
  bool isLoading = true;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  Future packageDetailsApi({required String packageId}) async {
    Map body = {"package_id": packageId};

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.labPackageDetails),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("============== packageDetails Api body ============== $body");
      debugPrint("============ packageDetails Api response ============ ${response.body}");

      var data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          packgeDetailApiModel = packgeDetailApiModelFromJson(response.body);
          if (packgeDetailApiModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${packgeDetailApiModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
      
    } catch (e) {
      debugPrint("============== packageDetails Api Error ============== $e");
    }
  }

}