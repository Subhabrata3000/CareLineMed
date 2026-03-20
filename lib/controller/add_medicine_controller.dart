import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import 'package:laundry/model/search_meditine_list_model.dart';

class AddMedicineController extends GetxController {
  bool reminder = false;
  TextEditingController medicinceTextValue = TextEditingController();
  bool isLoading = true;

  TimeOfDay? selectedTime;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.shrinkWrap;
  bool use24HourTime = false;

  List doseNames = [];
  List<TimeOfDay> doseTimes = [];
  String remiderId = "";

  List<Map<String, dynamic>> timedata = [];

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  SearchMeditineListModel? searchMeditineListModel;
  
  Future searchMeditineListApi({required String text}) async {

    Map body = {"text": text};

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.searchMeidicine),
        body: jsonEncode(body),
        headers: userHeader,
      );
      debugPrint("============== searchMeditineList Api url =============== ${Config.baseUrlDoctor + Config.searchMeidicine}");
      debugPrint("============== searchMeditineList Api body ============== $body");
      debugPrint("============ searchMeditineList Api response ============ ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          searchMeditineListModel = searchMeditineListModelFromJson(response.body);
          if (searchMeditineListModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${searchMeditineListModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
      }
    } catch (e) {
      debugPrint("============== searchMeditineList Api Error ============== $e");
    }
  }

  Future addMedicinceReminderApi({
    required String id,
    required String medicineName,
    required List<Map> time,
  }) async {

    Map body = {
      "id": id,
      "medicine_name": medicineName,
      "time": time,
      "status": reminder ? "1" : "0",
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.addMedicinceReminder),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("============== addMedicinceReminder Api url =============== ${Config.baseUrlDoctor + Config.addMedicinceReminder}");
      debugPrint("============== addMedicinceReminder Api body ============== $body");
      debugPrint("============ addMedicinceReminder Api response ============ ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          Fluttertoast.showToast(msg: "${data["message"]}");
          Get.back();
          update();
          return data;
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
      }
    } catch (e) {
      debugPrint("============== addMedicinceReminder Api Error ============== $e");
    }
  }

  Future editMedicinceReminderApi({
    required String id,
    required String medicineName,
    required String reminderId,
    required List<Map> time,
  }) async {
    Map body = {
      "id": id,
      "reminder_id": reminderId,
      "medicine_name": medicineName,
      "time": time,
      "status": reminder ? "1" : "0",
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.editMedicinceReminder),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("============== editMedicinceReminder Api url =============== ${Config.baseUrlDoctor + Config.editMedicinceReminder}");
      debugPrint("============== editMedicinceReminder Api body ============== $body");
      debugPrint("============ editMedicinceReminder Api response ============ ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          Fluttertoast.showToast(msg: "${data["message"]}");
          Get.back();
          update();
          return data;
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
      }
    } catch (e) {
      debugPrint("============== editMedicinceReminder Api Error ============== $e");
    }
  }

}