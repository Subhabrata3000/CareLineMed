import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/controller_doctor/time_slot_controller.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/doctor_detail_model.dart';

class DoctorDetailController extends GetxController implements GetxService {

  TimeSlotController timeSlotController = Get.put(TimeSlotController());

  DoctorDetailModel? doctorDetailModel;
  bool isLoading = true;
  int currentIndex = 0;
  int viewAllIndex = 0;
  num inPersonPrice = 0;
  num videoPrice = 0;
  int selectTab = 0;

  String priceChange = "";

  String subDepartmentId = "";
  String timeSelected = "";

  String showType = "";

  changeIndexInCategoryViewAll({int? index}) {
    viewAllIndex = index ?? 0;
    update();
  }

  changeIndexInCategory({int? index}) {
    currentIndex = index ?? 0;
    update();
  }

  List<String> imagePaths = [];

  Future doctorDetailApi({required String doctorId, required String departmentId}) async{

    Map body = {
      "id": getData.read("UserLogin") == null ? "0" : "${getData.read("UserLogin")["id"]}",
      "d_id": doctorId,
      "department_id": departmentId,
    };

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.doctorApi), body: jsonEncode(body), headers: userHeader);

    log(Config.baseUrlDoctor + Config.doctorApi, name: "----------- doctor Detail Api url ------------");
    log("$body", name: "----------- doctor Detail Api body -----------");
    log(response.body, name: "--------- doctor Detail Api response ---------");

    var data = jsonDecode(response.body);
    imagePaths = List<String>.from(data["gallery_list"].map((photo) => photo["image"]));
    if(response.statusCode == 200) {
      if(data['Result'] == true){
        doctorDetailModel = doctorDetailModelFromJson(response.body);
        update();
        if(doctorDetailModel!.result == true){
          showType = doctorDetailModel!.depSubSerList![0].showType!;
          selectTab = showType == "1"
            ? 0
            : showType == "2"
              ? 1
              : 0;
          if (showType == "1") {
            inPersonPrice = double.parse("${doctorDetailModel!.depSubSerList![0].clientVisitPrice}");
          } else if (showType == "2") {
            videoPrice = int.parse("${doctorDetailModel!.depSubSerList![0].videoConsultPrice}");
          } else {
            inPersonPrice = double.parse("${doctorDetailModel!.depSubSerList![0].clientVisitPrice}");
            videoPrice = num.parse("${doctorDetailModel!.depSubSerList![0].videoConsultPrice}");
          }

          priceChange = doctorDetailModel!.depSubSerList![0].showType!;

          if (priceChange == "1") {
            inPersonPrice = num.parse("${doctorDetailModel!.depSubSerList![0].clientVisitPrice}");
          } else if (priceChange == "2") {
            videoPrice = int.parse("${doctorDetailModel!.depSubSerList![0].videoConsultPrice}");
          } else {
            inPersonPrice = num.parse("${doctorDetailModel!.depSubSerList![0].clientVisitPrice}");
            videoPrice = num.parse("${doctorDetailModel!.depSubSerList![0].videoConsultPrice}");
          }

          subDepartmentId = doctorDetailModel!.depSubSerList![0].id.toString();
          timeSelected = doctorDetailModel!.alldate![0].date.toString();
          debugPrint("----------- subDepartmentId ------------ $subDepartmentId");
          isLoading = false;
          debugPrint("----------- subDepartmentId ------------ $subDepartmentId");
          update();
          return data;
        } else {
          Fluttertoast.showToast(msg: doctorDetailModel!.message.toString());
        }
      } else {
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}