import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/model/medicine_reminder_list_model.dart';

class MedicineReminderController extends GetxController {
  bool reminder = false;

  bool isLoding = true;

  MedicineReminderListModel? medicineReminderListModel;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future medicineReminderListApi() async {

    isLoding = true;
    update();

    Map body = {"id": "${getData.read("UserLogin")["id"]}"};

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.medicinceReminderList),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("============== medicineReminderList Api url =============== ${Config.baseUrlDoctor + Config.medicinceReminderList}");
      debugPrint("============== medicineReminderList Api body ============== $body");
      debugPrint("============ medicineReminderList Api response ============ ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          medicineReminderListModel = medicineReminderListModelFromJson(response.body);
          if (medicineReminderListModel!.result == true) {
            isLoding = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${medicineReminderListModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
      }
    } catch (e) {
      debugPrint("============== medicineReminderList Api Error ============== $e");
    }
  }

  Future deleteMedicinceReminderApi({
    required String id,
    required String reminderId,
  }) async {

    isLoding = true;
    update();

    Map body = {
      "id": id,
      "reminder_id": reminderId,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.deleteMedicinceReminder),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("============== deleteMedicinceReminder Api url =============== ${Config.baseUrlDoctor + Config.deleteMedicinceReminder}");
      debugPrint("============== deleteMedicinceReminder Api body ============== $body");
      debugPrint("============ deleteMedicinceReminder Api response ============ ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          Fluttertoast.showToast(msg: "${data["message"]}");
          medicineReminderListApi();
          update();
          return data;
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
      }
    } catch (e) {
      debugPrint("============== deleteMedicinceReminder Api Error ============== $e");
    }
  }
}
