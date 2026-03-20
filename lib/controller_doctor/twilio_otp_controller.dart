// ignore_for_file: unused_import, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Api/config.dart';
import '../model_doctor/twilio_otp_model.dart';
import '../utils/customwidget.dart';


class TwilioOtpController extends GetxController implements GetxService {
  TwilioOtpModel? twilioOtpModel;

  Future twilioOtpApi({required context, required String cCode,required String phone}) async {
    Map body = {
      "ccode": cCode,
      "phone": phone
    };
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.twilioOtp),
        body: jsonEncode(body), headers: userHeader);

    debugPrint("============ twilioApi body ============ ${body}");
    debugPrint("========== twilioapi response ========== ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        twilioOtpModel = twilioOtpModelFromJson(response.body);
        if (twilioOtpModel!.result == true) {
          showToastMessage("OTP:- ${data["otp"]}");
          update();
          return response.body;
        } else {
          Fluttertoast.showToast(msg: twilioOtpModel!.message.toString());
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
