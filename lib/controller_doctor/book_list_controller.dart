import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Api/config.dart';
import '../Api/data_store.dart';
import '../model_doctor/book_list_model.dart';
import 'package:http/http.dart' as http;

class BookListController extends GetxController implements GetxService {

  BookListModel? bookListModel;

  bool isLoading = false;


  bookListApi() async{
    Map body = {
      "id": getData.read("UserLogin")["id"].toString()
    };


    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};

    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.bookListAppointment), body: jsonEncode(body), headers: userHeader);

    debugPrint("============== booking List Api url ============= ${Config.baseUrlDoctor + Config.bookListAppointment}");
    debugPrint("============== booking List Api body ============ $body");
    debugPrint("============ booking List Api response ========== ${response.body}");
    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(data["Result"] == true){
        bookListModel = bookListModelFromJson(response.body);
        if(bookListModel!.result == true){
          isLoading = true;
          update();
        }
        else{
          Fluttertoast.showToast(msg: bookListModel!.message.toString());
        }
      }
      else{
        Fluttertoast.showToast(msg: "${data["message"]}",);
      }
    }
    else{
      Fluttertoast.showToast(msg: "Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added.",);
    }
  }
}
