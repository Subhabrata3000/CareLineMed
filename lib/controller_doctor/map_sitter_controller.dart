// ignore_for_file: prefer_typing_uninitialized_variables, unused_import, unnecessary_import

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:carelinemed/Api/config.dart';
import '../model_doctor/map_sitter_model.dart';

class MapSitterController extends GetxController implements GetxService {

  MapDoctorModel? mapDoctorModel;
  bool isLoading = false;
  PageController pageController = PageController();
  List<Marker> markers = [];
  GoogleMapController? mapController;


  updatePosition(String eventLatitude,String eventLongtitude){
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            double.parse(eventLatitude),
            double.parse(eventLongtitude),
          ),
          zoom: 12,
        ),
      ),
    ).then((val) {
      update();
    });
  }

  Future mapDoctorApi({required context,required String lat, required String long, required String radius}) async{
    Map body = {
      "latitude": lat,
      "longitude": long,
      "radius": radius,
    };
    Map<String, String> userHeader = {"Content-type": "application/json", "Accept": "application/json"};
    var response = await http.post(Uri.parse(Config.baseUrlDoctor + Config.mapDoctor),body: jsonEncode(body),headers: userHeader);

    debugPrint("------------- Map Doctor Api url ------------- ${Config.baseUrlDoctor + Config.mapDoctor}");
    debugPrint("------------- Map Doctor Api body ------------ $body");
    debugPrint("----------- Map Doctor Api response ---------- ${response.body}");

    var data = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(data["Result"] == true){
        mapDoctorModel = mapDoctorModelFromJson(response.body);
        if(mapDoctorModel!.result == true){
          isLoading = true;
          update();
        } else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mapDoctorModel!.message.toString()),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          );
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data["message"]}"),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        );
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Please update the content from the backend panel. It appears that the correct data was not uploaded, or there may be issues with the data that was added."),behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      );
    }
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

