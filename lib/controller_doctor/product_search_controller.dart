import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/data_store.dart';
import '../Api/config.dart';
import '../model_doctor/search_product_model.dart';

class ProductSearchController extends GetxController implements GetxService {

  ProductSearchModel? productSearchModel;
  bool isLoading = false;

  productSearchApi({required String doctorId, required String searchField}) async{
    Map body = {
      "uid": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "doctor_id": doctorId,
      "search_field": searchField
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.productSearch),body: jsonEncode(body),headers: userHeader);

    debugPrint("''''''''''' productSearch Api url '''''''''''' ${Config.baseUrlDoctor + Config.productSearch}");
    debugPrint("''''''''''' productSearch Api body ''''''''''' $body");
    debugPrint("''''''''' productSearch Api respons '''''''''' ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        productSearchModel = productSearchModelFromJson(response.body);
        if (productSearchModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: productSearchModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
