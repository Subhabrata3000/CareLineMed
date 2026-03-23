// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/model/font_family_model.dart';
import 'package:carelinemed/model/lab_booking_list_model.dart';
import 'package:http/http.dart' as http;

class LabBookingListController extends GetxController implements GetxService {
  LabBookingListModel? labBookingListModel;
  bool isLoading = true;

  String reasonmsg = "";
  String reasonId = "";

  TextEditingController cancelNotController = TextEditingController();

  var currency = "";

  @override
  void onInit() {
    currency = getData.read("currency");
    update();
    super.onInit();
  }

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future labBookingListApi() async {

    Map body = {
      "id": "${getData.read("UserLogin")["id"]}",
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.labBookingList),
        headers: userHeader,
        body: jsonEncode(body),
      );
      
      debugPrint("================ labBookingList Api body ================ $body");
      debugPrint("============== labBookingList Api response ============== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          labBookingListModel = labBookingListModelFromJson(response.body);
          if (labBookingListModel!.result == true) {
            isLoading = false;
            update();
            return data;
          } else {
            Fluttertoast.showToast(msg: "${labBookingListModel!.message}");
          }
        } else {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
    } catch (e) {
      debugPrint("================ labBookingList Api Error ================ $e");
    }
  }

  Future labBookingCancelApi({
    required String labBookId,
    required String reasonId,
    required String reason,
  }) async {

    Map body = {
      "id": "${getData.read("UserLogin")["id"]}",
      "lab_book_id": labBookId,
      "reason_id": reasonId,
      "reason": reason,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.cancelLabAppointment),
        headers: userHeader,
        body: jsonEncode(body),
      );
      
      debugPrint("================ labBookingCancel Api body ================ $body");
      debugPrint("============== labBookingCancel Api response ============== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          update();
          return data;
        } else {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
    } catch (e) {
      debugPrint("================ labBookingCancel Api Error ================ $e");
    }
  }

  Widget buttons({
    required VoidCallback onTap,
    required String buttonText,
    String? buttonIcon,
    required Color buttonColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: buttonColor,
          ),
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            buttonIcon == null
            ? SizedBox()
            : SizedBox(
                height: 20,
                child: SvgPicture.asset(
                  buttonIcon,
                  color: buttonColor,
                ),
              ),
            buttonIcon == null
            ? SizedBox()
            : SizedBox(width: 3),
            Text(
              buttonText,
              maxLines: 1,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 15,
                color: buttonColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
