import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/book_medicine_model.dart';

class BookMedicineController extends GetxController implements GetxService {

  BookMedicineListModel? medicineListModel;
  bool isLoading = false;


  bookMedicineListApi({required String appointmentId ,required String patientId}) async {

    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
      "patient_id": patientId
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };

    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.appointmentMedicineList), body: jsonEncode(body), headers: userHeader,
    );

    debugPrint("--------------- MedicineListApi body --------------- $body");
    debugPrint("------------- MedicineListApi response ------------- ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        medicineListModel = bookMedicineListModelFromJson(response.body);
        update();
        if (medicineListModel!.result == true) {
          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: medicineListModel!.message.toString());
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
