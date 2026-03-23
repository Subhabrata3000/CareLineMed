import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';

class ForgotPasswordController extends GetxController implements GetxService {
  bool isLoading = false;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };
  
  Future forgotPasswordApi({
    required String ccode,
    required String phone,
    required String password,
  }) async {
    Map body = {
      "ccode": ccode,
      "phone": phone,
      "password": password,
    };

    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.forgotPassword),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("============= Forgot Password Api body ============= $body");
    debugPrint("=========== Forgot Password Api response =========== ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: "${data["message"]}");
        return data;
      } else {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: "${data["message"]}");
        return data;
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
