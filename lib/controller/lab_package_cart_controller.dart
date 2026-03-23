import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/model/lab_package_cart_model.dart';
import 'package:http/http.dart' as http;

class LabPackageCartController extends GetxController implements GetxService {
  LabPackageCartApiModel? labPackageCartApiModel;
  bool isLoading = true;

  double homeCollectExtraPrice = 0;

  Map<int, List<int>> selectedPackagePatient = {};

  List packageTotal = [];
  List emptyList = [];

  String couponCode = "";
  var useWallet = 0.0;
  var tempWallet = 0.0;

  bool status = false;
  bool homeExtraPrice = false;

  String addresTitle = "";
  String addressId = "";
  double commission = 0;
  
  String couponId = "";
  double subTotal = 0;
  double total = 0;
  double apitotal = 0;
  int couponAmt = 0;

  TextEditingController caregiverController = TextEditingController();

  String sampleCollectDate = "";

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      sampleCollectDate = "${picked.day}-${picked.month}-${picked.year}";
      update();
    }
  }

  TimeOfDay? sampleCollectTime;

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: sampleCollectTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != sampleCollectTime) {
      sampleCollectTime = picked;
      update();
    }
  }

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future labPackageCartApi({
    required String uid,
    required String labId,
    required String categoryId,
  }) async {

    Map body = {
      "id": uid,
      "lab_id": labId,
      "category_id": categoryId,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.labPackageCart),
        headers: userHeader,
        body: jsonEncode(body),
      );
      
      debugPrint("================ labPackageCart Api url ================= ${Config.baseUrlDoctor + Config.labPackageCart}");
      debugPrint("================ labPackageCart Api body ================ $body");
      debugPrint("============== labPackageCart Api response ============== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          labPackageCartApiModel = labPackageCartApiModelFromJson(response.body);
          if (labPackageCartApiModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${labPackageCartApiModel!.message}");
          }
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
    } catch (e) {
      debugPrint("================ labPackageCart Api Error ================ $e");
    }
  }

  Future bookLabAppointmentApi({
    required String uid,
    required String labId,
    required String categoryId,
    required String date,
    required String time,
    required String message,
    required String address,
    required List packageList,
    required List familyMemId,
    required double totPrice,
    required double totPackagePrice,
    required double homeExtraPrice,
    required String homeColStatus,
    required String couponId,
    required double couponAmount,
    required double siteCommission,
    required String paymentId,
    required double walletAmount,
    required String transactionId,
  }) async {
    Map body = {
      "id": uid,
      "lab_id": labId,
      "category_id": categoryId,
      "date": date,
      "time": time,
      "message": message,
      "address": address,
      "package_list": packageList,
      "family_mem_id": familyMemId,
      "tot_price": totPrice,
      "tot_package_price": totPackagePrice,
      "home_extra_price": homeExtraPrice,
      "home_col_status": homeColStatus,
      "coupon_id": couponId,
      "coupon_amount": couponAmount,
      "site_commission": siteCommission,
      "payment_id": paymentId,
      "wallet_amount": walletAmount,
      "transactionId": transactionId,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.addLabBook),
        headers: userHeader,
        body: jsonEncode(body),
      );
      
      debugPrint("================ bookLabAppointment Api body ================ $body");
      debugPrint("============== bookLabAppointment Api response ============== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          Fluttertoast.showToast(msg: "${data["message"]}");
          update();
          return data;
        } else {
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
    } catch (e) {
      debugPrint("================ bookLabAppointment Api Error ================ $e");
    }
  }

}
