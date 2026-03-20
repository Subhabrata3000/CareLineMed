// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';
import '../helpar/routes_helper.dart';

class AddAddressController extends GetxController implements GetxService {

  var address;
  var lat;
  var long;
  getCurrentLatAndLong(double latitude, double longitude) {
    lat = latitude;
    long = longitude;
    Get.toNamed(Routes.deliveryaddress2);
    update();
  }

  bool isLoad = false;
  bool isCircle = false;


  addAddressApi({
    required String uId,
    required String houseNo,
    required String address,
    required String landmark,
    required String instruction,
    required String saveAddress,
    required String cCode,
    required String mobile,
    required String lan,
    required String long,
    required String googleAddress,
  }) async {

    if(isLoad){
      return;
    }else{
      isLoad = true;
    }

    Map body =  {
      "id": uId,
      "house_no": houseNo,
      "address": address,
      "landmark": landmark,
      "address_as": saveAddress,
      "country_code": cCode,
      "phone": mobile,
      "latitude": lan,
      "longitude": long,
      "google_address": googleAddress,
      "instruction": instruction,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.addAddress), body: jsonEncode(body), headers: userHeader);

    var data = jsonDecode(response.body);

    debugPrint("=========== addAddress Api url ============ ${Config.baseUrlDoctor + Config.addAddress}");
    debugPrint("========== addAddress Api body ============ $body");
    debugPrint("========= addAddress Api respons ========== ${response.body}");

    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        isLoad = false;
        isCircle = false;
        Fluttertoast.showToast(msg: "${data["message"]}");
        Get.close(3);
        update();
        return data;
      } else {
        isCircle = false;
        Fluttertoast.showToast(msg: "${data["message"]}",);
        update();
      }
    } else {
      isCircle = false;
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      update();
    }
  }
}



