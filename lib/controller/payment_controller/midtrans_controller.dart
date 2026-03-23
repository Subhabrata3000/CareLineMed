import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/data_store.dart';
import '../../Api/config.dart';

class MidTransController extends GetxController implements GetxService {
  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future midTransApi({required String amount}) async{
    Map body = {
      "amount": amount,
      "uid": "${getData.read("UserLogin")["id"]}",
      "status": 0,
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.midTrans), body: jsonEncode(body), headers: userHeader);

    debugPrint("------------ midTrans Api url --------------- ${Config.baseUrlDoctor + Config.midTrans}");
    debugPrint("------------ midTrans Api body -------------- $body");
    debugPrint("---------- midTrans Api response ------------ ${response.body}");


    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        Fluttertoast.showToast(msg: "${data["message"]}",);
        update();
        return jsonDecode(response.body);
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}",);
        return jsonDecode(response.body);
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }
  }

  Future midTransSuccessGetDataApi({required String orderId}) async{

    String url = "${Config.baseUrlDoctor}midtrans-success?order_id=$orderId&status=0";

    var response = await http.get(Uri.parse(url), headers: userHeader);

    debugPrint("============== midTrans Success GetData Api url =============== $url");
    debugPrint("============ midTrans Success GetData Api response ============ ${response.body}");

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
