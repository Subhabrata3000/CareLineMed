// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../model_doctor/otp_get_model.dart';

class OtpGetController extends GetxController implements GetxService {

  OtpGetModel? otpGetModel;

Future otpGetApi({required context}) async{

  Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
  var response = await http.get(Uri.parse(Config.baseUrlDoctor + Config.otpGet),headers: userHeader);

  debugPrint('${response.body}');

  var data = jsonDecode(response.body);
  if(response.statusCode == 200){
    if(data["Result"] == true){
      otpGetModel = otpGetModelFromJson(response.body);
      if(otpGetModel!.result == true){
        update();
        return data;
      }
    }
  }
  else{
    Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");

  }
}
}
