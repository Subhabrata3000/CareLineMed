import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/model_doctor/appint_cancel_reson_list_model.dart';
import 'package:http/http.dart' as http;

class AppintCancelResonListController extends GetxController implements GetxService {
  AppintCancelResonListModel? appintCancelResonListModel;
  bool isLoading = true;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future appintCancelResonListApi() async {
    try {
      var response = await http.get(
        Uri.parse(Config.baseUrlDoctor + Config.appintCancelList),
        headers: userHeader,
      );

      debugPrint("=========== Appoint Cancel Reson List Api response =========== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          appintCancelResonListModel = appintCancelResonListModelFromJson(response.body);
          if (appintCancelResonListModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${appintCancelResonListModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }

    } catch (e) {
      debugPrint("============= Appoint Cancel Reson List Api Error ============= $e");
    }
  }
}
