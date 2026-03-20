import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/model/lab_category_model.dart';
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
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
      
    } catch (e) {
      debugPrint("- - - - - - - - - - Lab Api Error - - - - - - - - - - $e");
    }
  }
}