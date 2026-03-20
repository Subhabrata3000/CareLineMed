import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import '../Api/data_store.dart';

class AddWalletController extends GetxController implements GetxService {

  TextEditingController amount = TextEditingController();

  addAmount({String? price}) {
    amount.text = price ?? "";
    update();
  }

  Future addWalletApi({required paymentType}) async{

    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "amount": amount.text,
      "payment_type": paymentType
    };
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.addWallet),body: jsonEncode(body),headers: userHeader);

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        Fluttertoast.showToast(msg: "${data["message"]}",);
        update();
        return response.body;
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}",);
        return response.body;
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }
  }

}