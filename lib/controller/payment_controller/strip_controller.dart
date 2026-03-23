import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Api/config.dart';


class StripController extends GetxController implements GetxService {

  Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

  Future stripApi({required String amount,required String uid}) async{
    Map body = {
      "amount": amount,
      "uid": uid,
      "status": 0,
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.strip), body: jsonEncode(body), headers: userHeader);

  debugPrint("============== Strip Api url =============== ${Config.baseUrlDoctor + Config.strip}");
  debugPrint("============== Strip Api body ============== $body");
  debugPrint("============ Strip Api response ============ ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["status"] == true){
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

  Future stripSuccessGetDataApi({required String paymentIntent}) async{

    String url = "${Config.baseUrlDoctor}strip-success?payment_intent=$paymentIntent&status=0";

    var response = await http.get(Uri.parse(url), headers: userHeader);

    debugPrint("============== stripSuccessGetData Api url =============== $url");
    debugPrint("============ stripSuccessGetData Api response ============ ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["status"] == true){
        update();
        Fluttertoast.showToast(msg: "${data["message"]}",);
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
