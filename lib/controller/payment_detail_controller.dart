// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import '../model/payment_detil_model.dart';
import '../model_doctor/wallet_payment_model.dart';

class PaymentDetailController extends GetxController implements GetxService {


  PaymentDetailModel? paymentDetailModel;

  bool isLoading = false;

  paymentDetailApi() async {
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.get(Uri.parse(Config.baseUrlDoctor + Config.paymentDetail), headers: userHeader,
    );

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        paymentDetailModel = paymentDetailModelFromJson(response.body);
        if(paymentDetailModel!.result == true){
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: paymentDetailModel!.message.toString());
        }
      }
      else{
        Fluttertoast.showToast(msg: "${data["status"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }

  WalletPaymentDetailModel? walletPaymentDetailModel;



  walletPaymentDetailApi() async {
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.get(Uri.parse(Config.baseUrlDoctor + Config.walletPaymentDetail), headers: userHeader, 
    );

    debugPrint("------------ walletPaymentDetail ------------- ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        walletPaymentDetailModel = walletPaymentDetailModelFromJson(response.body);
        if(walletPaymentDetailModel!.result == true){
          isLoading = true;
          update();
        }
        else{
          Fluttertoast.showToast(msg: walletPaymentDetailModel!.message.toString());
        }
      }
      else{
        Fluttertoast.showToast(msg: "${data["status"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }


}
