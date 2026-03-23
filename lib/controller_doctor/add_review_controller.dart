import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';

import '../Api/data_store.dart';
import '../model/add_review_model.dart';

class AddReviewController extends GetxController implements GetxService {

  AddReviewModel? addReviewModel;

  double tRate = 1.0;
  totalRateUpdate(double rating) {
    tRate = rating;
    update();
  }

  TextEditingController ratingText = TextEditingController();

  Future addReviewApi({required String appointmentId, required String review, required String starNo, required context}) async{
    Map body = {
      "id": getData.read("UserLogin")["id"].toString(),
      "appointment_id": appointmentId,
      "review": review,
      "tot_star": starNo,
    };

    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.addReview),body: jsonEncode(body),headers: userHeader);

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data["message"]}"),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        );
        Get.back();
        update();
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}",);
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.");
    }
  }
}
