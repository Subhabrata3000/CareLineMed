// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';

import '../model_doctor/msg_otp_model.dart';
import '../utils/customwidget.dart';


class MsgOtpController extends GetxController implements GetxService {
  MsgOtpModel? msgOtpModel;

  Future msgOtpApi({required context, required String cCode,required String phone}) async {
    Map body = {
      "ccode": cCode,
      "phone": phone
    };
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.msgOtp),
        body: jsonEncode(body), headers: userHeader);

    debugPrint("msgApi body ${body}");
    debugPrint("msgapi repsone ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        msgOtpModel = msgOtpModelFromJson(response.body);
        if (msgOtpModel!.result == true) {
          update();
          showToastMessage("OTP:- ${data["otp"]}");
          return response.body;
        } else {
          Fluttertoast.showToast(msg: msgOtpModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
