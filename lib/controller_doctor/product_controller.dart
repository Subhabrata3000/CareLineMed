import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/product_model.dart';

class ProductController extends GetxController implements GetxService {

  ProductModel? productModel;

  bool isLoading = false;

  Future productApi({required String doctorId,required String categoryId}) async{

    Map body = {
      "uid": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "doctor_id": doctorId,
      "category_id": categoryId
    };
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.productList),body: jsonEncode(body),headers: userHeader);

    debugPrint("''''''''''' product Api url '''''''''''' ${Config.baseUrlDoctor + Config.productList}");
    debugPrint("''''''''''' product Api body ''''''''''' $body");
    debugPrint("''''''''' product Api respons '''''''''' ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        productModel = productModelFromJson(response.body);
        if (productModel!.result == true) {
          isLoading = true;
          update();
          return response.body;
        } else {
          Fluttertoast.showToast(msg: productModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
