import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Api/config.dart';
import '../model/myorder_list_model.dart';
import 'package:http/http.dart' as http;

class MyOrderListController extends GetxController implements GetxService {

  MyOrderListModel? myOrderListModel;
  bool isLoading = false;

  myOrderListApi({required String uid}) async{

    Map body = {
      "uid": uid
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.myOrderList), body: jsonEncode(body), headers: userHeader);

    debugPrint("=========== myOrderList Api url ============ ${Config.baseUrlDoctor + Config.myOrderList}");
    debugPrint("========== myOrderList Api body ============ $body");
    debugPrint("========= myOrderList Api respons ========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        myOrderListModel = myOrderListModelFromJson(response.body);
        if (myOrderListModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: myOrderListModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."
      );
    }

  }

}
