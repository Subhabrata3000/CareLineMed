import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import '../Api/data_store.dart';
import '../model/edit_profile_model.dart';

class EditProfileController extends GetxController implements GetxService {

  EditProfileModel? editProfileModel;

  String? coverimagepath;
  String image = "";

  bool photoUplodLoading = false;

  bool isLoading = false;
  void updateLoading(bool value) {
    isLoading = value;
    update();
  }


  editProfileApi({required String name, required String email, required String cCode, required String phone, required String password, required context}) async {

    var request = http.MultipartRequest('POST', Uri.parse(Config.baseUrlDoctor + Config.editProfile));
    request.fields.addAll({
      'id': getData.read("UserLogin")["id"].toString(),
      'name': name,
      'email': email,
      'ccode': cCode,
      'phone': phone,
      'password': password,
    });
    if (coverimagepath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', coverimagepath!));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseBody);
      debugPrint("=============== Edit Profile Api url ================ ${Config.baseUrlDoctor + Config.editProfile}");
      debugPrint("=============== Edit Profile Api body =============== ${request.fields}");
      debugPrint("============= Edit Profile Api response ============= $data");

      if(data["Result"] == true) {
        Get.back();
        save("UserLogin", data["customer_detail"]);
        isLoading = false;
        update();
      }else{
        Fluttertoast.showToast(msg: "${data["message"]}");
        isLoading = false;
        update();
      }
    } else {
      Get.back();
      debugPrint(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.")));
    }

  }

}
