import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Api/config.dart';


class ShopAddOrderController extends GetxController implements GetxService {

  bool isLoad = false;
  bool isCircle = false;

  Future shopAddOrderApi({
    required String uid,
    required String sitterId,
    required num totalPrice,
    required String couponId,
    required num couponAmount,
    required num sitterCommission,
    required String address,
    required num walletAmount,
    required String paymentId,
    required String transactionId,
    List? productList,
  }) async{

    if(isLoad){
      return {"Result": false, "message": "Please wait..."};
    }else{
      isLoad = true;
    }

    Map body = {
      "uid": uid,
      "doctor_id": sitterId,
      "tot_price": totalPrice,
      "coupon": couponId == "" ? 0 : couponId,
      "coupon_amount": couponAmount,
      "site_commission": sitterCommission,
      "address": address,
      "wallet_amount": walletAmount,
      "payment_id": paymentId == "16" ? 1 : paymentId,
      "transactionId": transactionId == "" ? "TXN-${DateTime.now().millisecondsSinceEpoch}" : transactionId,
    };

    if (productList != null) {
      body["product_list"] = productList;
    }

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    try {
      var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.addOrderShop),body: jsonEncode(body),headers: userHeader);

      debugPrint("=========== shopAddOrder Api url ============ ${Config.baseUrlDoctor + Config.addOrderShop}");
      debugPrint("========== shopAddOrder Api body ============ $body");
      debugPrint("========= shopAddOrder Api respons ========== ${response.body}");
      
      var data = jsonDecode(response.body);

      if(response.statusCode == 200){
        if(data["Result"] == true){
          isLoad = false;
          isCircle = false;
          update();
          return jsonDecode(response.body);
        }else{
          isLoad = false;
          isCircle = false;
          Fluttertoast.showToast(msg: "${data["message"]}");
          update();
          return jsonDecode(response.body);
        }
      }else{
        isLoad = false;
        isCircle = false;
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
        update();
        return {"Result": false, "message": "Server error ${response.statusCode}"};
      }
    } catch(e) {
      isLoad = false;
      isCircle = false;
      update();
      return {"Result": false, "message": e.toString()};
    }
  }
}
