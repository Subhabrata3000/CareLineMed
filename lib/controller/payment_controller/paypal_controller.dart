import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Api/config.dart';
import '../../model/payment_model/paypal_model.dart';

class PayPalController extends GetxController implements GetxService {

  PaypalModel? paypalModel;

 Future paypalApi({required String amount, required String uid}) async{
  Map body = {
    "amount": amount,
    "uid": uid,
    "status": 0,
  };

  Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
  var response = await http.post(
    Uri.parse(Config.baseUrlDoctor + Config.paypal),
    body: jsonEncode(body),
    headers: userHeader,
  );

  debugPrint("============== Paypal Api url =============== ${Config.baseUrlDoctor + Config.paypal}");
  debugPrint("============== Paypal Api body ============== $body");
  debugPrint("============ Paypal Api response ============ ${response.body}");

  var data = jsonDecode(response.body);

  if(response.statusCode == 200){
    if(data["status"] == true){
      Fluttertoast.showToast(msg: "${data["message"]}",);
      update();
      return jsonDecode(response.body);
    }
    else{
      Fluttertoast.showToast(msg: "${data["message"]}",);
      return jsonDecode(response.body);
    }
  }
  else{
    Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
  }
}
}
