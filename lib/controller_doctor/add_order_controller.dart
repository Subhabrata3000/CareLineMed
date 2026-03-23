import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';

import '../Api/data_store.dart';

class AddOrderController extends GetxController implements GetxService {

  bool isOrderLoading = false;

  setOrderLoading() {
    isOrderLoading = true;
    update();
  }

  setOrderLoadingOff() {
    isOrderLoading = false;
    update();
  }


  bool isLoad = false;


   Future addOrderApi({
     required String doctorId,
     required String subDepId,
     required String hospitalID,
     required String departmentID,
     required String dateTime,
     required String showType,
     required String showTypePrice,
     required String familyId,
     required String message,
     required String couponId,
     required String couponAmount,
     required String address,
     required String totalPrice,
     required String additionalPrice,
     required String doctorCommission,
     required String siteCommission,
     required String paymentType,
     required String walletAmount,
     required String dateType,
     required String time,
     required String transactionId,
     required context,
    }) async {

     if(isLoad){
       return {"Result": false, "message": "Please wait..."};
     }else{
       isLoad = true;
     }

     Map body = {
       "id": getData.read("UserLogin")["id"].toString(),
       "d_id": doctorId,
       "sub_depar_id": subDepId,
       "hospital_id": hospitalID,
       "department_id": departmentID,
       "date": dateTime,
       "date_type": dateType,
       "time": time,
       "family_mem_id": familyId,
       "show_type": showType,
       "show_type_price": showTypePrice,
       "tot_price": totalPrice,
       "additional_price": additionalPrice,
       "coupon_id": couponId,
       "coupon_amount": couponAmount,
       "doctor_commission": doctorCommission,
       "site_commisiion": siteCommission,
       "payment_id": paymentType,
       "wallet_amount": walletAmount,
       "additional_note": message,
       "address": address,
       "transactionId": transactionId,
     };
     Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

     try {
       var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.bookAppointment),body: jsonEncode(body),headers: userHeader);

       debugPrint("============== addOrder Api url =============== ${Config.baseUrlDoctor + Config.bookAppointment}");
       debugPrint("============== addOrder Api body ============== $body");
       debugPrint("============ addOrder Api response ============ ${response.body}");

       var data = jsonDecode(response.body);
       if(response.statusCode == 200){
         if(data["Result"] == true){
           isLoad = false;
           // Fluttertoast.showToast(msg: "${data["message"]}");
           update();
           return jsonDecode(response.body);
         }
         else{
           isLoad = false;
           Fluttertoast.showToast(msg: "${data["message"]}");
           return jsonDecode(response.body);
         }
       }
       else{
         isLoad = false;
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.")));
         return {"Result": false, "message": "Server error ${response.statusCode}"};
       }
     } catch(e) {
       isLoad = false;
       return {"Result": false, "message": e.toString()};
     }
   }
}
