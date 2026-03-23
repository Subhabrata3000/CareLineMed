import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';

import '../Api/data_store.dart';
import '../model_doctor/pdf_model.dart';

class PdfController extends GetxController implements GetxService {

  PdfModel? pdfModel;

  bool isLoading = false;



  Future downloadPdf({required String appointmentId, required String familyId}) async{
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
      "family_mem_id": familyId,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.pdfDownload),body: jsonEncode(body),headers: userHeader);

    var data = jsonDecode(response.body);

    debugPrint("============ Download Pdf Api url ============= ${Config.baseUrlDoctor + Config.pdfDownload}");
    debugPrint("============ Download Pdf Api body ============ $body");
    debugPrint("========== Download Pdf Api response ========== ${response.body}");
    if(response.statusCode == 200){
      if(data["Result"] == true){
        pdfModel = pdfModelFromJson(response.body);
       if(pdfModel!.result == true){
         isLoading = true;
         update();
       } else {
         Fluttertoast.showToast(msg: pdfModel!.message.toString());
       }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}",);
      }
    } else {
      // Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
