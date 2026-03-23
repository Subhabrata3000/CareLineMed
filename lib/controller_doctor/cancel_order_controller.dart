// ignore_for_file: unused_import, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/cancel_order_model.dart';
import '../utils/custom_colors.dart';
import 'book_list_controller.dart';

class CancelBookController extends GetxController implements GetxService {

  BookListController bookListController = Get.put(BookListController());

  CancelOrderModel? cancelOrderModel;
  bool isLoading = false;


  final note = TextEditingController();


  cancelOrderListApi() async{

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.get(Uri.parse(Config.baseUrlDoctor + Config.cancelOrderList),headers: userHeader);

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        cancelOrderModel = cancelOrderModelFromJson(response.body);
        if(cancelOrderModel!.result == true){
          isLoading = true;
          update();
        }else{
          Fluttertoast.showToast(msg: cancelOrderModel!.message.toString());
        }
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }


  var selectedRadioTile;
  String? rejectMsg = '';


  cancelOrderApi({required String appointmentId}) async{

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
      "reason_id": selectedRadioTile.toString(),
      "reason": note.text
    };

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.cancelOrderApi),body: jsonEncode(body), headers: userHeader);

    debugPrint("============================== ${response.body}");
    debugPrint("============================== $body");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        bookListController.bookListApi();
        Get.close(2);
        Fluttertoast.showToast(msg: "${data["message"]}",textColor: WhiteColor,backgroundColor: BlackColor);
        isLoading = true;
        update();
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}");
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }




}
