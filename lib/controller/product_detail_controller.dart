import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/screen/shop/product.dart';
import '../Api/config.dart';
import '../model/product_detail_model.dart';

class ProductDetailController extends GetxController implements GetxService {

  ProductDetailModel? productDetailModel;
  bool isLoading = false;
  List<String> imagePaths = [];

  Map<String, dynamic>? dropdownvalue;
  List<Map<String, dynamic>> productAllPrice = [];

  Future productDetailApi({required String sitterId, required String prodId}) async{
    Map body = {
      "uid": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "doctor_id": sitterId,
      "prod_id": prodId
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.productDetails),body: jsonEncode(body),headers: userHeader);

    debugPrint("''''''''''' product details url '''''''''''' ${Config.baseUrlDoctor + Config.productDetails}");
    debugPrint("''''''''''' product details body ''''''''''' $body");
    debugPrint("''''''''' product details respons '''''''''' ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        productDetailModel = productDetailModelFromJson(response.body);
        if(productDetailModel!.result == true) {
          if (productCartQuntityList.containsKey("dr_$sitterId") == false) {
            productCartQuntityList.addAll({"dr_$sitterId" : {}});
          }
          debugPrint("================== productCartQuntityList ================ $productCartQuntityList");
          productCartQuntityList["dr_$sitterId"].addAll({"tot_cart_qty": productDetailModel!.totCartQty});
          int qtyTotal = 0;
          List productQty = [];
          for(int i = 0; i < productDetailModel!.product!.priceDetail!.length; i++) {
            productQty.add({ "${productDetailModel!.product!.priceDetail![i].title}" : productDetailModel!.product!.priceDetail![i].cartQty});
          }
          for (var item in productQty) {
            item.forEach((key, value) {
              qtyTotal += value as int;
            });
          }
          debugPrint("------------- qtyTotal ------------ $qtyTotal");
          debugPrint("------------ productQty ----------- $productQty");
          if (productCartQuntityList["dr_$sitterId"].containsKey("${productDetailModel!.product!.id}") == false) {
            productCartQuntityList["dr_$sitterId"].addAll({
              "${productDetailModel!.product!.id}" : {
                "tot_product_qty" : "$qtyTotal",
                "cart_qty_title" : productQty.toList(),
              },
            });
          }
          save("CartQuntry", productCartQuntityList);
          debugPrint("============ productQuntityList =========== $productCartQuntityList");
          debugPrint("=============== CartQuntry ================ ${getData.read("CartQuntry")}");
          isLoading = true;
          update();
          return data;
        } else {

        Fluttertoast.showToast(msg: productDetailModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
