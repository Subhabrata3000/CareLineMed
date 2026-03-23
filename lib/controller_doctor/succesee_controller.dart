// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import '../Api/data_store.dart';

import '../model_doctor/succesee_model.dart';

class SucceseeControllerController extends GetxController implements GetxService {

  SucceseeApiModel? succeseeApiModel;
  bool isLoading = false;

  num serviceAndText = 0;

  var currency;

  Future successApiDoctor({
    required String appointmentId,
  }) async {

    Map body = {
      "id": "${getData.read("UserLogin")["id"]}",
      "appointment_id": appointmentId,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.success), body: jsonEncode(body), headers: userHeader);

   debugPrint("><><><>>><><>Succesee><><><><><><$body");
   debugPrint("><><><>>>Succesee<><>><><><><><><${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['Result'] == true) {
        succeseeApiModel = succeseeApiModelFromJson(response.body);
        update();
        if (succeseeApiModel!.result == true) {
          serviceAndText = succeseeApiModel!.appointData.doctorCommission + succeseeApiModel!.appointData.siteCommisiion;
          isLoading = true;
          update();
        }  else {
          Fluttertoast.showToast(msg: succeseeApiModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }

  }
}
