import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Api/config.dart';
import '../model/address_list_model.dart';

class AddressListController extends GetxController implements GetxService {

  AddressListModel? addressListModel;
  bool isLoading = false;

  addressListApi({required String uid}) async{
    Map body = {
      "id": uid
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.shopAddressList), body: jsonEncode(body), headers: userHeader);

    debugPrint("=========== addressList Api url ============ ${Config.baseUrlDoctor + Config.shopAddressList}");
    debugPrint("========== addressList Api body ============ $body");
    debugPrint("========= addressList Api respons ========== ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        addressListModel = addressListModelFromJson(response.body);
        if(addressListModel!.result == true){
          isLoading = true;
          update();
        }
        else{
          Fluttertoast.showToast(msg: addressListModel!.result.toString());
        }
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}",);
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }
  }
}
