import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';

class SenangPayController extends GetxController implements GetxService {

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future senangPayApi({required String amount}) async{
    Map body = {
      "amount": amount,
      "uid": "${getData.read("UserLogin")["id"]}",
      "status": 0,
    };


    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.senangPayPayment),
      body: jsonEncode(body),
      headers: userHeader,
    );

    var data = jsonDecode(response.body);

    debugPrint("------------ senangPay Api url --------------- ${Config.baseUrlDoctor + Config.senangPayPayment}");
    debugPrint("------------ senangPay Api body -------------- $body");
    debugPrint("---------- senangPay Api response ------------ ${response.body}");


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

  Future senangPaySuccessGetDataApi({required String trxref,required String reference}) async{

    String url = "${Config.baseUrlDoctor}paystack-check?status=0&trxref=$trxref&reference=$reference";

    var response = await http.get(Uri.parse(url), headers: userHeader);

    debugPrint("============== senangPay Success GetData Api url =============== $url");
    debugPrint("============ senangPay Success GetData Api response ============ ${response.body}");

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
