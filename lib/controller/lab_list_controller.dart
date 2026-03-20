import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/model/lab_list_model.dart';
import 'package:laundry/screen/authentication/onbording_screen.dart';
import 'package:http/http.dart' as http;

class LabListController extends GetxController implements GetxService {
  LabListApiModel? labListApiModel;
  bool isLoading = true;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future labListApi({required String categoryId}) async {

    Map body = {
      "category_id": categoryId,
      "lat": lat,
      "lon": long,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.labList),
        headers: userHeader,
        body: jsonEncode(body),
      );
      
      debugPrint("================ Lab List Api body ================ $body");
      debugPrint("============== Lab List Api response ============== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          labListApiModel = labListApiModelFromJson(response.body);
          if (labListApiModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${labListApiModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }

    } catch (e) {
      debugPrint("================ Lab List Api Error ================ $e");
    }
  }
}