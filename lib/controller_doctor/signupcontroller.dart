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

class SignUpController extends GetxController implements GetxService {

  bool isLoading = false;

  Future sighUpApi({
    required context,
    required String name,
    required String email,
    required String cCode,
    required String phone,
    required String password,
    required String referralCode,
  }) async {

    isLoading = true;
    update();

    Map body = {
      "Name": name,
      "Email": email,
      "ccode": cCode,
      "phone": phone,
      "Password": password,
      "referral_code": referralCode,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.signUpDoctor), body: jsonEncode(body), headers: userHeader);

    debugPrint("============== signUp Api body ============== $body");
    debugPrint("============ signUp Api response ============ ${response.body}");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        save("UserLogin", data["customer"]);
        log("++++++++++++++++++++++++++++++++++++++++ ${getData.read("UserLogin")["id"]}");
        loginSharedPreferencesSet(false);
        isLoading = false;
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.bottombarProScreen, (route) => false);
        initPlatformState();
        OneSignal.User.addTags({"subscription_user_Type": 'customer', "Login_ID": data["customer"]["id"].toString()});
        update();
        return response.body;
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("${data["message"]}")));
      }

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.")));
    }
  }
}
