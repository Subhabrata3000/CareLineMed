// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import 'package:laundry/controller/favorite_add_controller.dart';

import '../Api/data_store.dart';
import '../model_doctor/cart_detail_model.dart';
import '../screen/bottombarpro_screen.dart';

class CartDetailController extends GetxController implements GetxService {

  CartDetailModel? cartDetailModel;
  double total = 0;
  double totalResult = 0;
  double sitterCharge = 0;
  double serviceTax = 0;
  double commission = 0;
  bool isLoading = false;
  String addresTitle = "";
  String addressId = "";
  int couponAmt = 0;
  String couponId = "";
  int additionalPetCharge = 0;

  String hospital = "";

  changeIndex(int index) {
    currentIndexBottom = index;
    update();
  }

  bool isOrderLoading = false;

  Future cartDetailApi({required String doctorId,required String subDepartmentId, required String hospitalId}) async {
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "d_id": doctorId,
      "sub_depar_id": subDepartmentId,
      "hospital_id": hospitalId
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.cartDetail), body: jsonEncode(body), headers: userHeader);

    debugPrint("- - - - - - - - cartDetail api url - - - - - - - - - ${Config.baseUrlDoctor + Config.cartDetail}");
    debugPrint("- - - - - - - - cartDetail api body - - - - - - - -  $body");
    debugPrint("- - - - - - - cartDetail api response - - - - - - -  ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        cartDetailModel = cartDetailModelFromJson(response.body);
        if(cartDetailModel!.result == true){
          isLoading = true;
          update();
          return data;
        }
        else{
          Fluttertoast.showToast(msg: cartDetailModel!.message.toString());
        }
      } else{
        Fluttertoast.showToast(msg: "${data["message"]}",);
      }
    }
    else{
      Get.back();
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }

  }
}
