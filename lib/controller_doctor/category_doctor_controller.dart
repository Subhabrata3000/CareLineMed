import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../model_doctor/category_doctor_model.dart';
import '../screen/authentication/onbording_screen.dart';

class CategoryDoctorController extends GetxController implements GetxService {

  CategoryTypeDoctorModel? categoryTypeDoctorModel;
  bool isLoading = false;

  categoryDoctorApi({required String departmentId}) async{

    Map body = {
      "department_id": departmentId,
      "lat": lat.toString(),
      "lon": long.toString()
    };

    Map<String,String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.categoryDoctor),body: jsonEncode(body),headers: userHeader);

    debugPrint("============== Category Doctor url =============== ${Config.baseUrlDoctor + Config.categoryDoctor}");
    debugPrint("============== Category Doctor body ============== $body");
    debugPrint("============ Category Doctor response ============ ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if (data["Result"] == true) {
        categoryTypeDoctorModel = categoryTypeDoctorModelFromJson(response.body);
        if (categoryTypeDoctorModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: categoryTypeDoctorModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}