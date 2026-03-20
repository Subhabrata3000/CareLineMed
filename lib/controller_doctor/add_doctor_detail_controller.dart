// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import '../model_doctor/add_doctor_detail_model.dart';


class AddDoctorDetailController extends GetxController implements GetxService{

  AddDoctorDetailModel? addDoctorDetailModel;

  addDoctorApi() async{

    Map<String,String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    var response = await http.get(Uri.parse(Config.baseUrlDoctor + Config.familyMemberAddDetail),headers: userHeader);

    debugPrint("=========== family Member Add Detail response =========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        addDoctorDetailModel = addDoctorDetailModelFromJson(response.body);
        update();
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}