// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';

import '../model_doctor/category_model.dart';

class CategoryController extends GetxController implements GetxService{

  CategoryModel? categoryModel;
  bool isLoading = false;

  categoryApi() async {
    isLoading = false;
    update();

    Map<String,String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.get(Uri.parse(Config.baseUrlDoctor + Config.categoryList),headers: userHeader);

    debugPrint("================ category Api Url =================== ${Config.baseUrlDoctor + Config.categoryList}");
    debugPrint("============== category Api response ================ ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if (data["Result"] == true) {
        categoryModel = categoryModelFromJson(response.body);
        if (categoryModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: categoryModel!.message);
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
