import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/utils/custom_colors.dart';

class ShopOrderCancelController extends GetxController {

  bool isLoading = false;
   
  Future shopOrderCancelApi({required String orderId, required String cancelId, required String reason}) async {
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    Map body = {
      "order_id": orderId,
      "cancel_id": "",
      "reason": reason,
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.orderCancelShop), body: jsonEncode(body), headers: userHeader);

    debugPrint("================= shopOrderCancelApi url ================== ${Config.baseUrlDoctor + Config.orderCancelShop}");
    debugPrint("================= shopOrderCancelApi body ================= $body");
    debugPrint("=============== shopOrderCancelApi response =============== ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        Fluttertoast.showToast(msg: "${data["message"]}",textColor: WhiteColor,backgroundColor: gradient.defoultColor);
        isLoading = true;
        update();
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }

}
