import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../helpar/routes_helper.dart';
import '../screen/authentication/onbording_screen.dart';
import '../utils/customwidget.dart';

class LoginController extends GetxController implements GetxService {

  Future loginApi({required context,required String cCode,required String phone, required String password}) async {
    Map body;
    if (cCode.isEmpty) {
      body = {
        "email": phone, // phone parameter holds the email address here
        "password": password,
      };
    } else {
      body = {
        "ccode": cCode,
        "phone": phone,
        "password": password,
      };
    }

    Map<String,String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response =  await http.post(Uri.parse(Config.baseUrlDoctor + Config.loginDoctor),body: jsonEncode(body),headers: userHeader);

    debugPrint("-------------- login api url --------------- ${Config.baseUrlDoctor + Config.loginDoctor}");
    debugPrint("-------------- login api body -------------- $body");
    debugPrint("------------ login api Response ------------ ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        save("UserLogin", data["customer_detail"]);
        log("++++++++++++++++++++++++++++++++++++++++ ${getData.read("UserLogin")["id"]}");
        loginSharedPreferencesSet(false);
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.bottombarProScreen, (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data["message"]}"),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        );
        initPlatformState();
        OneSignal.User.addTags({"subscription_user_Type": 'customer', "Login_ID": data["customer_detail"]["id"].toString()});
        update();
      } else {
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data["message"]}"),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
        );
      }

    } else {
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
      );
    }
  }
}
