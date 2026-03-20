import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';

import '../model_doctor/page_list_model.dart';

class PageListController extends GetxController implements GetxService {

  PageListModel? pageListModel;
  bool isLoading = false;

  pageListApi(context) async{

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.pages),headers: userHeader);

    debugPrint("***************************** ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        pageListModel = pageListModelFromJson(response.body);
        isLoading = true;
        update();

      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }
      else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.")));
    }
  }
}