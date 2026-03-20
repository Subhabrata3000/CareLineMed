import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Api/config.dart';

class CheckMobileController extends GetxController implements GetxService {
  Future checkMobileApi({
    String? cCode,
    String? phone,
    String? email,
  }) async {
    Map body = {
      "email": email ?? "",
      "ccode": cCode ?? "",
      "phone": phone ?? "",
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.mobileCheckDoctor),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("============== Check Mobile Api body ============== $body");
    debugPrint("============ Check Mobile Api Response ============ ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        update();
        return response.body;
      } else {
        update();
        return response.body;
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
