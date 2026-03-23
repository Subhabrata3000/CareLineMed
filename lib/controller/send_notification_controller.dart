import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/screen/video_call/vc_provider.dart';
import '../Api/data_store.dart';

class SendNotificationController extends GetxController implements GetxService {

  bool sendNotifiactionLoding = false;


  sendNotificationApi({required context, required String doctorId}) async{
    sendNotifiactionLoding = true;
    update();
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "doctor_id": doctorId
    };
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.sendNotification),body: jsonEncode(body),headers: userHeader);

    log(Config.baseUrlDoctor + Config.doctorApi, name: "----------- Send Notification Api url ------------");
    log("$body", name: "----------- Send Notification Api body -----------");
    log(response.body, name: "--------- Send Notification Api response ---------");

    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        sendNotifiactionLoding = false;
        showToastMessage("${data["message"]}");
        update();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data["message"]}"),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      );
    }
  }
}
