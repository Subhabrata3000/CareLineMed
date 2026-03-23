// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import '../Api/data_store.dart';
import '../model/favorite_add_remove_model.dart';


class FavoriteAddController extends GetxController implements GetxService {

  FavoriteAddRemoveModel? favoriteAddRemoveModel;

  bool isLoading = false;

  Future favoriteAddApi({required String doctorId, required String departmentId}) async {
    isLoading = true;
    update();

    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "d_id": doctorId,
      "department_id": departmentId,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.favoriteAdd),body: jsonEncode(body),headers: userHeader);
    
    debugPrint("----------- favoriteAddApi body ----------- $body");
    debugPrint("--------- favoriteAddApi response --------- ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true) {
        update();
        return data;
      } else {
        Get.back();
        Fluttertoast.showToast(msg: "${data["message"]}",);
      }
    } else {
      Get.back();
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }
  }
}
