import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:laundry/Api/config.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/data_store.dart';

class DeleteAccountController extends GetxController implements GetxService {
  bool isLoading = true;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future deleteAccountApi() async {

    Map body = {
      "id": "${getData.read("UserLogin")["id"]}",
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.deleteAccount),
        headers: userHeader,
        body: jsonEncode(body),
      );

      debugPrint("================ Delete Account Api body ================ $body");
      debugPrint("============== Delete Account Api response ============== ${response.body}");

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
      debugPrint("================ Delete Account Api Error ================ $e");
    }
  }
}