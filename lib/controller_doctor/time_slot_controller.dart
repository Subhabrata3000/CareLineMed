import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../model_doctor/time_slot_model.dart';

class TimeSlotController extends GetxController implements GetxService {

  TimeSlotModel? timeSlotModel;
  bool isLoading = true;
  Future timeSlotApi({
    required String doctorId,
    required String hospitalId,
    required String departmentId,
    required String date,
  }) async{
    isLoading = true;
    update();
    Map body = {
      "d_id": doctorId,
      "hospital_id": hospitalId,
      "department_id": departmentId,
      "date": date,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };

    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.doctorTimeSlot),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("============ time Slot Api url ============= ${Config.baseUrlDoctor + Config.doctorTimeSlot}");
    debugPrint("============ time Slot Api body ============ $body");
    debugPrint("========== time Slot Api response ========== ${response.body}");


    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        timeSlotModel = timeSlotModelFromJson(response.body);
        if (timeSlotModel!.result == true) {
          isLoading = false;
          update();
          return response.body;
        } else {
          Fluttertoast.showToast(msg: timeSlotModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg:
      "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}