import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../model/shop_coupon_model.dart';

class ShopCouponController extends GetxController implements GetxService {


  ShopCouponModel? shopCouponModel;
  bool isLoading = false;

  shopCouponApi({required String orderId}) async{
    Map body = {
      "doctor_id": orderId
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.shopCouponList), body: jsonEncode(body), headers: userHeader);

    debugPrint("=========== shopCoupon api url ============== ${Config.baseUrlDoctor + Config.shopCouponList}");
    debugPrint("=========== shopCoupon api body ============= $body");
    debugPrint("========= shopCoupon api respons ============ ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        shopCouponModel = shopCouponModelFromJson(response.body);
        if (shopCouponModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: shopCouponModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."
      );
    }
  }
}