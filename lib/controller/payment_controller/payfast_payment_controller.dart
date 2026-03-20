import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import 'package:laundry/Api/data_store.dart';

class PayfastPaymentController extends GetxController implements GetxService {

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future payfastPaymentApi({required String amount}) async{
    Map body = {
      "uid": "${getData.read("UserLogin")["id"]}",
      "amount": amount,
      "status": 0,
    };

    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.payfastPayment),
      body: jsonEncode(body),
      headers: userHeader,
    );

    var data = jsonDecode(response.body);

    debugPrint("------------ Payfast Payment Api url --------------- ${Config.baseUrlDoctor + Config.payfastPayment}");
    debugPrint("------------ Payfast Payment Api body -------------- $body");
    debugPrint("---------- Payfast Payment Api response ------------ ${response.body}");


    if (response.statusCode == 200) {
      if (data["status"] == true) {
        Fluttertoast.showToast(msg: "${data["message"]}");
        update();
        return jsonDecode(response.body);
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
        return jsonDecode(response.body);
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }
  }

  Future payfastSuccessGetDataApi({required String transactionId}) async {
    Map body = {"transactionId": transactionId};

    String url = "${Config.baseUrlDoctor}${Config.getPayfastTransactionid}";

    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("============== payfast Success GetData Api url =============== $url");
    debugPrint("============= payfast Success GetData Api body =============== $body");
    debugPrint("============ payfast Success GetData Api response ============ ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["status"] == true) {
        update();
        Fluttertoast.showToast(msg: "${data["message"]}",);
        return jsonDecode(response.body);
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}",);
        return jsonDecode(response.body);
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}