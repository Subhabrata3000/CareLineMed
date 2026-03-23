import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/model/lab_category_model.dart';
import 'package:http/http.dart' as http;

class LabCategoryController extends GetxController implements GetxService {
  LabCategoryApiModel? labCategoryApiModel;
  bool isLoding = true;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future labApi() async {
    try {

      var response = await http.get(
        Uri.parse(Config.baseUrlDoctor + Config.labCategoryList),
        headers: userHeader,
      );
      
      debugPrint("- - - - - - - - - - Lab Api response - - - - - - - - - - ${response.body}");
      
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          labCategoryApiModel = labCategoryApiModelFromJson(response.body);
          if (labCategoryApiModel!.result == true) {
            isLoding = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${labCategoryApiModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "No Partner Lab in your location");
      }
      
    } catch (e) {
      debugPrint("- - - - - - - - - - Lab Api Error - - - - - - - - - - $e");
    }
  }
}
