import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Api/config.dart';
import '../../model/payment_model/flutterwave_model.dart';


class FlutterWaveController extends GetxController implements GetxService {

  FlutterWaveModel? flutterWaveModel;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future flutterWaveApi({required String amount,required String uid}) async{
    Map body = {
      "amount": amount,
      "uid": uid,
      "status": 0,
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.flutterWave), body: jsonEncode(body), headers: userHeader);

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
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }
  }

  Future flutterWaveSuccessGetDataApi({
    required String txref,
    required String transactionId,
  }) async{

    String url = "${Config.baseUrlDoctor}flutterwave-check?typecheck=0&status=successful&tx_ref=$txref&transaction_id=$transactionId";

    var response = await http.get(Uri.parse(url), headers: userHeader);

    debugPrint("============== flutter Wave Success Get Data Api url =============== $url");
    debugPrint("============ flutter Wave Success Get Data Api response ============ ${response.body}");

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
