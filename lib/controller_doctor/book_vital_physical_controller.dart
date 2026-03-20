import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/book_vital_physical_model.dart';

class BookVitalPhysicalController extends GetxController implements GetxService {

  BookVitalPhysicalModel? bookVitalPhysicalModel;
  bool isLoading = false;
  List<TextEditingController> controllers = [];
  Map<int, String> updatedValues = {};


  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    super.dispose();
  }


  bookVitalListApi({required String appointmentId, required String patientId}) async {
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
      Uri.parse(Config.baseUrlDoctor + Config.appointmentDetailVital), body: jsonEncode(body), headers: userHeader,
    );

    debugPrint("============ bookVital List Api body ============ $body");
    debugPrint("========== bookVital List Api response ========== ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data["Result"] == true) {
        bookVitalPhysicalModel = bookVitalPhysicalModelFromJson(response.body);
        update();

        if (bookVitalPhysicalModel!.result == true) {
          for (var controller in controllers) {
            controller.dispose();
          }
          controllers.clear();

          final listLength = bookVitalPhysicalModel!.vitPhyList.length;
          controllers = List.generate(
            listLength,
                (index) {
              TextEditingController controller = TextEditingController(
                text: bookVitalPhysicalModel!.vitPhyList[index].text,
              );

              // Listen for changes in the text field
              controller.addListener(() {
                updatedValues[bookVitalPhysicalModel!.vitPhyList[index].id] =
                    controller.text.trim();
              });

              return controller;
            },
          );


          isLoading = true;
          update();
        } else {
          Fluttertoast.showToast(msg: bookVitalPhysicalModel!.message.toString());
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

  List<Map<String, String>> getUpdatedValues() {
    List<Map<String, String>> finalList = [];

    // Iterate through the API data and controllers
    for (int i = 0; i < bookVitalPhysicalModel!.vitPhyList.length; i++) {
      var item = bookVitalPhysicalModel!.vitPhyList[i];
      String currentValue = controllers[i].text.trim(); // Get text from controller

      // If the text field has data (either from API or user input), include it
      if (currentValue.isNotEmpty) {
        finalList.add({
          "id": item.id.toString(),
          "text": currentValue,
        });
      }
    }

    return finalList;
  }




}

