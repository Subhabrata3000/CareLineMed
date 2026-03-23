import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/model/packages_model.dart';
import 'package:http/http.dart' as http;

class PackagesController extends GetxController implements GetxService {
  PackagesApiModel? packagesApiModel;
  bool isLoading = true;

  late List cartPopularTestsLoding;
  late List cartAffordableLoding;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  Future packagesApi({
    required String categoryId,
    required String labId,
  }) async {
    Map body = {
      "id": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "category_id": categoryId,
      "lab_id": labId,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.labPackageList),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("------------- packages Api body ------------- $body");
      debugPrint("----------- packages Api response ----------- ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          packagesApiModel = packagesApiModelFromJson(response.body);
          if (packagesApiModel!.result == true) {
            cartPopularTestsLoding = List.filled(packagesApiModel!.individual!.length, false);
            cartAffordableLoding = List.filled(packagesApiModel!.package!.length, false);
            isLoading = false;
            update();
            debugPrint("------------ cartPopularTestsLoding ------------ $cartPopularTestsLoding");
            debugPrint("------------- cartAffordableLoding ------------- $cartAffordableLoding");
            return data;
          } else {
            Fluttertoast.showToast(msg: "${packagesApiModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }

    } catch (e) {
      debugPrint("------------- packages Api Error ------------- $e");
    }
  }

  Future packageAddinCartApi({
    required String labId,
    required String pacakgeId,
  }) async {
    Map body = {
      "id": "${getData.read("UserLogin")["id"]}",
      "lab_id": labId,
      "package_id": pacakgeId,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.labAddCart),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("------------- packageAddinCart Api body ------------- $body");
      debugPrint("----------- packageAddinCart Api response ----------- ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          isLoading = false;
          update();
          return data;
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }

    } catch (e) {
      debugPrint("------------- packageAddinCart Api Error ------------- $e");
    }
  }
}
