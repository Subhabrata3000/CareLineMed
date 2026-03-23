import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/screen/shop/product.dart';
import '../Api/data_store.dart';
import '../model_doctor/product_list_model.dart';

class ProductListController extends GetxController implements GetxService {

  ProductListModel? productListModel;
  bool isLoading = false;

  Future productListApi({required String doctorId, required String categoryId}) async {
    isLoading = false;
    update();
    Map body = {
      "uid": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "doctor_id": doctorId,
      "category_id": categoryId
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.productSubList),body: jsonEncode(body),headers: userHeader);

    debugPrint("''''''''''' productList Api url '''''''''''' ${Config.baseUrlDoctor + Config.productSubList}");
    debugPrint("''''''''''' productList Api body ''''''''''' $body");
    debugPrint("''''''''' productList Api response ''''''''' ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        productListModel = productListModelFromJson(response.body);
        if (productListModel!.result == true) {
          return data;
        } else {
          Fluttertoast.showToast(msg: productListModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }

  Future fetchInitialData({required String scId, required String doctorId}) async {
    isLoading = false;
    debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
    update();
    if (getData.read("CartQuntry") != null) {
      productCartQuntityList.addAll(getData.read("CartQuntry"));
      debugPrint("================== productCartQuntityList 1 ================ $productCartQuntityList");
    }
    try {
      await productListApi(
        doctorId: doctorId.toString(),
        categoryId: scId,
      ).then((value) {
        if (value["Result"] == true) {
          if (value["Result"] == true) {
            for (var i = 0; i < productListModel!.productList!.length; i++) {
              int qtyTotal = 0;
              List productQty = [];
              if (productCartQuntityList.containsKey("dr_$doctorId") == false) {
                productCartQuntityList.addAll({"dr_$doctorId": {}});
              }
              productCartQuntityList["dr_$doctorId"].addAll({
                "tot_cart_qty": productListModel!.totCartQty
              });
              for (var j = 0; j < productListModel!.productList![i].priceDetail!.length; j++) {
                productQty.add({"${productListModel!.productList![i].priceDetail![j].title}": productListModel!.productList![i].priceDetail![j].cartQty});
                update();
              }
              for (var item in productQty) {
                item.forEach((key, value) {
                  qtyTotal += value as int;
                });
              }
              debugPrint("================= productQty =============== $productQty");
              debugPrint("================== qtyTotal ================ $qtyTotal");
              if (productCartQuntityList["dr_$doctorId"].containsKey("${productListModel!.productList![i].id}") == false) {
                productCartQuntityList["dr_$doctorId"].addAll({
                  "${productListModel!.productList![i].id}": {
                    "tot_product_qty": "$qtyTotal",
                    "cart_qty_title": productQty.toList(),
                  },
                });
                debugPrint("=============== log 1 ===============");
              } else {
                debugPrint("=============== log 2 ===============");
                productCartQuntityList["dr_$doctorId"]["${productListModel!.productList![i].id}"]["tot_product_qty"] = "$qtyTotal";
                productCartQuntityList["dr_$doctorId"]["${productListModel!.productList![i].id}"]["cart_qty_title"] = productQty.toList();
                debugPrint("------------- productCartQuntityList - productCartQuntityList :---- ${productCartQuntityList["dr_$doctorId"]["${productListModel!.productList![i].id}"]["tot_product_qty"]}");
                debugPrint("----------------- productCartQuntityList - cart_qty_title :-------- ${productCartQuntityList["dr_$doctorId"]["${productListModel!.productList![i].id}"]["cart_qty_title"]}");
              }
              debugPrint("================== productQuntityList ================ $productCartQuntityList");
            }
            debugPrint("================== CartQuntry ================ ${getData.read("CartQuntry")}");
            isLoading = true;
            update();
          }
        }
      });
    } finally {
      isLoading = true;
      update();
    }
    return isLoading;
  }
}
