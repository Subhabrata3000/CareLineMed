import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:laundry/model_doctor/refer_earn_model.dart';

class ReferCodeController extends GetxController implements GetxService {
  ReferEarnModel? referEarnModel;
  bool isLoading = false;

  referCodeApi() async {
    Map body = {"id": "${getData.read("UserLogin")["id"]}"};

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.referralData),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("============ referCode Api body ============ $body");
    debugPrint("========== referCode Api response ========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        referEarnModel = referEarnModelFromJson(response.body);
        if (referEarnModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: referEarnModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
