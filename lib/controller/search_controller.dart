import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/Api/config.dart';

import '../model/search_model.dart';

class SearchHomeController extends GetxController implements GetxService {

  SearchModel? searchModel;
  bool isLoading = false;

  Map<String, String> userHeader = {
    "Content-type": "application/json",
    "Accept": "application/json",
  };

  Future searchApi({required context, required String search, required String lat, required String long}) async {

    String safeLat = (lat.isEmpty || lat == "null") ? "0.0" : lat;
    String safeLong = (long.isEmpty || long == "null") ? "0.0" : long;

    Map body = {
      "text": search,
      "lat": safeLat,
      "lon": safeLong
    };

    var response = await http.post(
      Uri.parse(Config.baseUrlDoctor + Config.searchDoctor),
      body: jsonEncode(body),
      headers: userHeader,
    );

    debugPrint("=============== URL  =============== ${Config.baseUrlDoctor + Config.searchDoctor}");
    debugPrint("=============== BODY ============== $body");
    debugPrint("=============== RESPONSE ============ ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200) {
      if (data["Result"] == true || data["Result"] == "true") {
        searchModel = searchModelFromJson(response.body);

        if(searchModel!.result == true){
          isLoading = true;
          update();
          return data;
        } else {
          isLoading = true;
          update();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(searchModel!.message ?? "No doctors found")),
          );
        }
      } else {
        isLoading = true;
        update();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Unknown Error")),
        );
      }
    }
    else {
      isLoading = true;
      update();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Server Error: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}