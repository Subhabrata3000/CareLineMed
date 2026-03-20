import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:laundry/Api/config.dart';
import 'package:laundry/model_doctor/faq_list_model.dart';
import 'package:http/http.dart' as http;

class FaqListController extends GetxController implements GetxService {
  FaqListModel? faqListModel;
  bool isLoading = true;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future faqListApi() async {
    try {
      var response = await http.get(
        Uri.parse(Config.baseUrlDoctor + Config.faqList),
        headers: userHeader,
      );

      debugPrint("============= Faq List Api response ============= ${response.body}");
      
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          faqListModel = faqListModelFromJson(response.body);
          if (faqListModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${faqListModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }

    } catch (e) {
      debugPrint("============= Faq List Api Error ============= $e");
    }
  }
}