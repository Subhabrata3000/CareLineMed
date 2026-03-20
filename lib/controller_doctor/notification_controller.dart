import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/model/notification_model.dart';

class NotificationController extends GetxController implements GetxService {
  bool isLoading = true;
  NotificationListApiModel? notificationListApiModel;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future notificationLiatApi() async {
    Map body = {"id": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}"};

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.notificationList),
        body: jsonEncode(body),
        headers: userHeader,
      );
      debugPrint("============== Notifiaction List api body ============== $body");
      debugPrint("============ Notifiaction List api response ============ ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          notificationListApiModel = notificationListApiModelFromJson(response.body);
          if (notificationListApiModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${notificationListApiModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }

    } catch (e) {
      debugPrint("============== Notifiaction List api Error ============== $e");
    }
    
  }
}