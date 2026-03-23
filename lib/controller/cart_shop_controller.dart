import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/model/cart_shop_model.dart';
import '../Api/config.dart';

class CartShopController extends GetxController implements GetxService {

  CartShopModel? cartShopModel;
  bool isLoading = false;
  bool isLoad = false;
  bool isCircle = false;


  Future cartShopApi({
    required String uid,
    required int proQtyType,
    required String sitterId,
    required num proPrice,
    required String propType,
    required String prodId,
    required num proQty,
    required String mode,
  }) async {

    if(isLoad){
      return;
    }else{
      isLoad = true;
    }

    Map body = {
      "uid": uid,
      "doctor_id": sitterId,
      "prod_id": prodId,             // mode = 0 - Blank,         mode = 1 - Value,                                                   mode = 2 - Value
      "pro_price": proPrice,         // mode = 0 - Blank,         mode = 1 - Value,                                                   mode = 2 - Blank
      "pro_ptype": propType,         // mode = 0 - Blank,         mode = 1 - Value,                                                   mode = 2 - Blank
      "pro_qty": proQty,             // mode = 0 - Blank,         mode = 1 - Value,                                                   mode = 2 - Blank
      "pro_qty_type": proQtyType,    // mode = 0 - Blank,         mode = 1 - Value : 1 = Increase / Value : 2 = Decrease,             mode = 2 - Blank
      "mode": mode,                  // 0 - Detail,               1 - Add:Edit,                                                       2 - Remove
    };
    debugPrint("+++++++++++++++ cartShop Api body ++++++++++++ $body");

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.cartShop), body: jsonEncode(body),headers: userHeader);
    debugPrint("+++++++++++++++ cartShop Api url +++++++++++++ ${Config.baseUrlDoctor + Config.cartShop}");
    debugPrint("++++++++++++++ cartShop Api respons ++++++++++ ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        cartShopModel = cartShopModelFromJson(response.body);
        if(cartShopModel!.result == true){
          isLoading = true;
          isLoad = false;
          isCircle = false;
          update();
          return data;
        } else {
          isCircle = false;
          Fluttertoast.showToast(msg: cartShopModel!.message.toString());
          update();
        }
      } else {
        isCircle = false;
        Fluttertoast.showToast(msg: "${data["message"]}");
        update();
      }
    } else {
      isCircle = false;
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      update();
    }
  }
}
