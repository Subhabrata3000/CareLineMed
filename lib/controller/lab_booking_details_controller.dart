import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:carelinemed/Api/config.dart';
import 'package:carelinemed/Api/data_store.dart';
import 'package:carelinemed/model/lab_booking_details_model.dart';
import 'package:http/http.dart' as http;

class LabBookingDetailsController extends GetxController implements GetxService {
  LabBookingDetailsModel? labBookingDetailsModel;
  bool isLoading = true;

  List packageTotal = [];

  List checkStatusDateAndTime = [];

  bool isPdf(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }
  

  IconData getFileIcon(String path) {
    if (path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png') || path.endsWith('.heic') || path.endsWith('.tiff') || path.endsWith('.webp') || path.endsWith('.bmp') || path.endsWith('.gif')) {
      return Icons.image;
    } else if (path.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else {
      return Icons.insert_drive_file;
    }
  }

  late Uint8List bytes;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  List<Map> orderListHomeCollect = [
    { "id": 1, "title": "Pending", "dis": "Waiting for confirmation from the laboratory.".tr  },
    { "id": 2, "title": "Accepted", "dis": "Laboratory has accepted the appointment request.".tr },
    { "id": 3, "title": "Collector Assigned", "dis": "A Laboratory technician has been assigned for sample collection.".tr },
    { "id": 4, "title": "Ongoing", "dis": "Sample collection is in progress.".tr },
    { "id": 5, "title": "Processing", "dis": "Sample is being analyzed in the lab.".tr },
    { "id": 6, "title": "Completed", "dis": "Report is ready and available for download.".tr },
  ];

  List<Map> orderList = [
    { "id": 1, "title": "Pending", "dis": "Waiting for confirmation from the laboratory.".tr },
    { "id": 2, "title": "Accepted", "dis": "Laboratory has accepted the appointment request.".tr },
    { "id": 4, "title": "Ongoing", "dis": "The appointment is currently in progress.".tr },
    { "id": 5, "title": "Processing", "dis": "Lab tests are being processed and analyzed.".tr },
    { "id": 6, "title": "Completed", "dis": "The appointment and all related tests are completed.".tr },
  ];

  List<Map> orderCancel = [
    { "id": 1, "title": "Pending", "dis": "Waiting for confirmation from the laboratory.".tr },
    { "id": 7, "title": "Cancel", "dis": "" },
  ];

  List<OrderStatus> statusoresrList = [];

  Future labBookingDetailsApi({required String labBookId}) async {
    packageTotal.clear();
    statusoresrList.clear();
    update();

    Map body = {
      "id": "${getData.read("UserLogin")["id"]}",
      "lab_book_id": labBookId,
    };

    try {
      var response = await http.post(
        Uri.parse(Config.baseUrlDoctor + Config.labBookingDetail),
        headers: userHeader,
        body: jsonEncode(body),
      );
      
      debugPrint("================ labBookingDetails Api url ================= ${Config.baseUrlDoctor + Config.labBookingDetail}");
      debugPrint("================ labBookingDetails Api body ================ $body");
      debugPrint("============== labBookingDetails Api response ============== ${response.body}");

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["Result"] == true) {
          labBookingDetailsModel = labBookingDetailsModelFromJson(response.body);
          if (labBookingDetailsModel!.result == true) {
            final String base64Image = "${labBookingDetailsModel!.appoint!.qrcode}";
            final String cleanedBase64 = base64Image.split(",").last;
            bytes = base64Decode(cleanedBase64);
            for (var i = 0; i < labBookingDetailsModel!.appoint!.packageId!.length; i++) {
              double packageTotalAmt = labBookingDetailsModel!.appoint!.packageId![i].f!.length * double.parse("${labBookingDetailsModel!.appoint!.packageId![i].totPackagePrice}");
              packageTotal.add(packageTotalAmt);
            }
            if (labBookingDetailsModel!.appoint!.status == "7") {
              for (var timeI = 0; timeI < labBookingDetailsModel!.appoint!.statusList!.length; timeI++) {
                statusoresrList.add(
                  OrderStatus(
                    sid: "${labBookingDetailsModel!.appoint!.statusList![timeI].s}",
                    title: orderCancel[timeI]["title"],
                    subtitle: timeI == 0 ? orderCancel[timeI]["dis"] : (labBookingDetailsModel!.appoint!.cancelReason == "" ? "${labBookingDetailsModel!.appoint!.cancelTitle}" : "${labBookingDetailsModel!.appoint!.cancelReason}"),
                    timestamp: "${labBookingDetailsModel!.appoint!.statusList![timeI].t}",
                    isCompleted: true,
                  ),
                );
              }
            } else if (labBookingDetailsModel!.appoint!.homeColStatus == "1") {
              for (var timeI = 0; timeI < orderListHomeCollect.length; timeI++) {
                statusoresrList.add(
                  OrderStatus(
                    sid: labBookingDetailsModel!.appoint!.statusList!.length <= timeI ? " " : "${labBookingDetailsModel!.appoint!.statusList![timeI].s}",
                    title: orderListHomeCollect[timeI]["title"],
                    subtitle: orderListHomeCollect[timeI]["dis"],
                    timestamp: labBookingDetailsModel!.appoint!.statusList!.length <= timeI ? " " : "${labBookingDetailsModel!.appoint!.statusList![timeI].t}",
                    isCompleted: labBookingDetailsModel!.appoint!.statusList!.length <= timeI ? false : true,
                  ),
                );
              }
              debugPrint("----------- statusoresrList ----------- ${statusoresrList.length}");
              debugPrint("----------- statusList ----------- ${labBookingDetailsModel!.appoint!.statusList!.length}");
            } else if (labBookingDetailsModel!.appoint!.homeColStatus == "0") {
              for (var timeI = 0; timeI < orderList.length; timeI++) {
                statusoresrList.add(
                  OrderStatus(
                    sid: labBookingDetailsModel!.appoint!.statusList!.length <= timeI ? " " : "${labBookingDetailsModel!.appoint!.statusList![timeI].s}",
                    title: orderList[timeI]["title"],
                    subtitle: orderList[timeI]["dis"],
                    timestamp: labBookingDetailsModel!.appoint!.statusList!.length <= timeI ? " " : "${labBookingDetailsModel!.appoint!.statusList![timeI].t}",
                    isCompleted: labBookingDetailsModel!.appoint!.statusList!.length <= timeI ? false : true,
                  ),
                );
              }
            }
            isLoading = false;
            update();
            return data;
          } else {
            isLoading = false;
            update();
            Fluttertoast.showToast(msg: "${labBookingDetailsModel!.message}");
          }
        } else {
          isLoading = false;
          update();
          Fluttertoast.showToast(msg: "${data["message"]}");
        }
      } else {
        isLoading = false;
        update();
        Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
      }
    } catch (e) {
      isLoading = false;
      update();
      debugPrint("================ labBookingDetails Api Error ================ $e");
    }
  }
}


class OrderStatus {
  final String sid;
  final String title;
  final String subtitle;
  final String timestamp;
  final bool isCompleted;

  OrderStatus({
    required this.sid,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isCompleted,
  });
}
