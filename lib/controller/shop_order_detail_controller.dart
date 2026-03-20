import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/product_detail_model.dart';
import '../model/shop_order_detail_model.dart';
import '../Api/config.dart';

class ShopOrderDetailController extends GetxController implements GetxService {

  ShopOrderDetailModel? shopOrderDetailModel;
  bool isLoading = false;
  List<Product> productList = [];

  shopOrderDetailApi({required String uid, required String orderId}) async{
    Map body = {
      "uid": uid,
      "order_id": orderId,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.shopOrderDetail), body: jsonEncode(body), headers: userHeader);

    debugPrint("=========== myOrderList Api url ============ ${Config.baseUrlDoctor + Config.shopOrderDetail}");
    debugPrint("========== myOrderList Api body ============ $body");
    debugPrint("========= myOrderList Api respons ========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        shopOrderDetailModel = shopOrderDetailModelFromJson(response.body);
        if (shopOrderDetailModel!.result == true) {
          isLoading = true;
          productList = shopOrderDetailModel!.productList!.cast<Product>();
          update();
        } else {
          Fluttertoast.showToast(msg: shopOrderDetailModel!.message.toString());
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