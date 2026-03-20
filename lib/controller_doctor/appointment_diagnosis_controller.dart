import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/appoiment_diagnosis_model.dart';


class BookDiagnosisController extends GetxController implements GetxService {

  AppointmentDiagnosisModel? appointmentDiagnosisModel;
  bool isLoading = false;

  bookDiagnosisListApi({required String appointmentId, required String patientId}) async {
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
      "patient_id": patientId
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.appointmentDiagnosis), body: jsonEncode(body), headers: userHeader,
    );

    debugPrint("============ BookDiagnosis List Api body ============ $body");
    debugPrint("========== BookDiagnosis List Api response ========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        appointmentDiagnosisModel = appointmentDiagnosisModelFromJson(response.body);
        update();
        if (appointmentDiagnosisModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: appointmentDiagnosisModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."
      );
    }
  }

}

