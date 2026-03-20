import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/controller_doctor/pdf_controller.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/apointmnet_detail_model.dart';

class AppointmentDetailDoctorController extends GetxController implements GetxService {

  PdfController pdfController = Get.put(PdfController());

  int vitalsPhysical = 0;
  int drugsPrescription = 0;
  int diagnosisTest = 0;

  AppointmentDetailModel? appointmentDetailModel;
  bool isLoading = false;
  late Uint8List bytes;

  String patientID = "";

  num serviceFeeTax = 0;

  List communicationIcon = ["assets/Call.svg", "assets/chat-text.svg"];
  List communicationText = ["Call", "Message"];

  List appointmentChecklistsTitle = [
    "Vitals & Physical Information",
    "Drugs & Prescription Info",
    "Diagnosis Tests",
  ];

  List appointmentChecklistsSubTitle = [
    "Physical examination details",
    "Medications prescribed and dosage instructions",
    "Medical tests and diagnostic evaluations",
  ];

  late int countdownStart;
  late int remainingTime;
  Timer? timer;

  void startTimer(int timecount) {
    countdownStart = timecount; // Directly use API value
    remainingTime = countdownStart;

    timer?.cancel(); // Cancel any previous timer to avoid duplication

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        update(); // Assuming you're using GetX for state management
      } else {
        timer.cancel();
        update();
      }
    });
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future appointmentDoctorApi({required String appointmentId}) async {
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
    };

    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.appointmentDetail),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("============ Appointment Doctor Api url ============= ${Config.baseUrlDoctor + Config.appointmentDetail}");
    debugPrint("============ Appointment Doctor Api body ============ $body");
    debugPrint("========== Appointment Doctor Api response ========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        appointmentDetailModel = appointmentDetailModelFromJson(response.body);
        if (appointmentDetailModel!.result == true) {
          patientID = appointmentDetailModel!.familyMember![0].id.toString();
          serviceFeeTax = num.parse("${appointmentDetailModel!.appoint!.doctorCommission}") + num.parse("${appointmentDetailModel!.appoint!.siteCommisiion}") ;
          pdfController.downloadPdf(appointmentId: appointmentId, familyId: patientID);
          final String base64Image = appointmentDetailModel!.appoint!.qrcode!.toString();
          final String cleanedBase64 = base64Image.split(",").last;
          bytes = base64Decode(cleanedBase64);
          vitalsPhysical = int.parse("${appointmentDetailModel!.appoint!.vitalsPhysical}");
          drugsPrescription = int.parse("${appointmentDetailModel!.appoint!.drugsPrescription}");
          diagnosisTest = int.parse("${appointmentDetailModel!.appoint!.diagnosisTest}");
          debugPrint("------------ vitalsPhysical ------------- $vitalsPhysical");
          debugPrint("---------- drugsPrescription ------------ $drugsPrescription");
          debugPrint("------------- diagnosisTest ------------- $diagnosisTest");
          int? parsedTimecount = int.tryParse(appointmentDetailModel!.appoint!.timecount.toString());
          if (parsedTimecount != null) {
            countdownStart = parsedTimecount * 60;
            remainingTime = countdownStart;
            isLoading = true; // Set before starting timer for better UX
            update();
            startTimer(parsedTimecount);
            update();
            return response.body;
          } else {
            Fluttertoast.showToast(msg: appointmentDetailModel!.message.toString());
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
    }
  }

  bool checkDoctorAppointment = false;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json"
  };

  Future checkDoctorAppointmentUploadApi({required String appointmentId, required String fid}) async {
    Map body = {
      "id": "${getData.read("UserLogin")["id"]}",
      "appointment_id": appointmentId,
      "fid": fid,
    };
    checkDoctorAppointment = true;
    update();


    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.checkDocAppointUpload),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("============ check Doctor Appointment Upload Api url ============= ${Config.baseUrlDoctor + Config.checkDocAppointUpload}");
    debugPrint("============ check Doctor Appointment Upload Api body ============ $body");
    debugPrint("========== check Doctor Appointment Upload Api response ========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        vitalsPhysical = int.parse("${data["vitals_physical"]}");
        drugsPrescription = int.parse("${data["drugs_prescription"]}");
        diagnosisTest = int.parse("${data["diagnosis_test"]}");
        debugPrint("------------ vitalsPhysical ------------- $vitalsPhysical");
        debugPrint("---------- drugsPrescription ------------ $drugsPrescription");
        debugPrint("------------- diagnosisTest ------------- $diagnosisTest");
        checkDoctorAppointment = false;
        update();
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    } else {
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}