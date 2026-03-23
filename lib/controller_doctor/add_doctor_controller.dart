// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/controller_doctor/add_doctor_detail_controller.dart';
import 'package:carelinemed/model_doctor/family_member_detail_model.dart';

import '../Api/data_store.dart';
import '../utils/customwidget.dart';

class AddPatientController extends GetxController implements GetxService {

  TextEditingController nameController = TextEditingController();
  TextEditingController relationShipController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nationalController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  TextEditingController historyController = TextEditingController();

  FamilyMemberDetailModel? familyMemberDetailModel;

  AddDoctorDetailController addDoctorDetailController = Get.put(AddDoctorDetailController());

  String relationShipId = "";
  String bloodId = "";


  File? galleryFile;
  XFile? xFileImage;

  var selectedGender;

  bool detailsLoding = false;

  bool isLoading = false;

  void updateLoading(bool value) {
    isLoading = value;
    update();
  }

  Map<String,String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future addPatientApi({required context}) async {
    var request = http.MultipartRequest('POST', Uri.parse(Config.baseUrlDoctor + Config.addFamilyMember));
    request.fields.addAll({
      'customer_id': getData.read("UserLogin")["id"].toString(),
      'name': nameController.text,
      'relationship': relationShipId.toString(),
      'blood_type': bloodId.toString(),
      'gender': selectedGender.toString(),
      'patient_age': ageController.text,
      'national_id': nationalController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'allergies': allergiesController.text,
      'medical_history': historyController.text
    });
    request.files.add(await http.MultipartFile.fromPath('profile_image', xFileImage!.path));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseBody);
      debugPrint("++++++++++++ Add Patient Api body ++++++++++++++++++ ${request.fields}");
      debugPrint("++++++++++ Add Patient Api response ++++++++++++++++ $data");

      if(data["Result"] == true) {
        Get.back();
        isLoading = false;
        update();
      }else{
        snackBar(context: context, text: "${data["message"]}");
        isLoading = false;
        update();
      }
    } else {
      debugPrint(response.reasonPhrase);
      snackBar(context: context, text: "SomeThing Went Wrong");
    }
  }

  Future editPatientApi({required context,required String fid}) async {
    var request = http.MultipartRequest('POST', Uri.parse(Config.baseUrlDoctor + Config.editFamilyMember));
    request.fields.addAll({
      'fid': fid,
      'name': nameController.text,
      'relationship': relationShipId.toString(),
      'blood_type': bloodId.toString(),
      'gender': selectedGender.toString(),
      'patient_age': ageController.text,
      'national_id': nationalController.text,
      'height': heightController.text,
      'weight': weightController.text,
      'allergies': allergiesController.text,
      'medical_history': historyController.text
    });

     debugPrint("++++++++++++ Add Patient Api body ++++++++++++++++++ ${request.fields}");
    if (xFileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', xFileImage!.path));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseBody);
      debugPrint("++++++++++++ Add Patient Api body ++++++++++++++++++ ${request.fields}");
      debugPrint("++++++++++ Add Patient Api response ++++++++++++++++ $data");

      if(data["Result"] == true) {
        Get.back();
        isLoading = false;
        update();
      }else{
        snackBar(context: context, text: "${data["message"]}");
        isLoading = false;
        update();
      }
    } else {
      debugPrint(response.reasonPhrase);
      snackBar(context: context, text: "SomeThing Went Wrong");
    }
  }
  
  Future familyMemberDetailApi({required String fid}) async {
    detailsLoding = true;
    update();
    Map body = {"fid": fid};

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.familyMemberDetail),
        body: jsonEncode(body),
        headers: userHeader,
      );

      debugPrint("============ Family Member Details Api body ============ $body");
      debugPrint("========== Family Member Details Api response ========== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          familyMemberDetailModel = familyMemberDetailModelFromJson(response.body);
          if (familyMemberDetailModel!.result == true) {
            nameController.text = "${familyMemberDetailModel!.data!.name}";
            relationShipId = "${familyMemberDetailModel!.data!.relationship}";
            bloodId = "${familyMemberDetailModel!.data!.bloodType}";
            nationalController.text = "${familyMemberDetailModel!.data!.nationalId}";
            ageController.text = "${familyMemberDetailModel!.data!.patientAge}";
            selectedGender = "${familyMemberDetailModel!.data!.gender}";
            heightController.text = "${familyMemberDetailModel!.data!.height}";
            weightController.text = "${familyMemberDetailModel!.data!.weight}";
            historyController.text = "${familyMemberDetailModel!.data!.medicalHistory}";
            allergiesController.text = "${familyMemberDetailModel!.data!.allergies}";
            for (var i = 0; i < addDoctorDetailController.addDoctorDetailModel!.relationshipList.length; i++) {
              if (int.parse("${familyMemberDetailModel!.data!.relationship}") == addDoctorDetailController.addDoctorDetailModel!.relationshipList[i].id) {
                relationShipController.text = addDoctorDetailController.addDoctorDetailModel!.relationshipList[i].name;
              }
            }
            for (var j = 0; j < addDoctorDetailController.addDoctorDetailModel!.bloodGroupList.length; j++) {
              if (int.parse("${familyMemberDetailModel!.data!.bloodType}") == addDoctorDetailController.addDoctorDetailModel!.bloodGroupList[j].id) {
                bloodController.text = addDoctorDetailController.addDoctorDetailModel!.bloodGroupList[j].name;
              }
            }
            detailsLoding = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${familyMemberDetailModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }

    } catch (e) {
      debugPrint("============ Family Member Details Api Error ============ $e");
    }

  }

}
