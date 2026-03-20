// To parse this JSON data, do
//
//     final mapDoctorModel = mapDoctorModelFromJson(jsonString);

import 'dart:convert';

MapDoctorModel mapDoctorModelFromJson(String str) => MapDoctorModel.fromJson(json.decode(str));

String mapDoctorModelToJson(MapDoctorModel data) => json.encode(data.toJson());

class MapDoctorModel {
  int responseCode;
  bool result;
  String message;
  List<DoctorList> doctorList;

  MapDoctorModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.doctorList,
  });

  factory MapDoctorModel.fromJson(Map<String, dynamic> json) => MapDoctorModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    doctorList: List<DoctorList>.from(json["doctor_list"].map((x) => DoctorList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "doctor_list": List<dynamic>.from(doctorList.map((x) => x.toJson())),
  };
}

class DoctorList {
  int id;
  String logo;
  String title;
  String subtitle;
  String address;
  String latitude;
  String longitude;
  String zoneName;
  String departmentId;
  num totReview;
  num avgStar;

  DoctorList({
    required this.id,
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.zoneName,
    required this.departmentId,
    required this.totReview,
    required this.avgStar,
  });

  factory DoctorList.fromJson(Map<String, dynamic> json) => DoctorList(
    id: json["id"],
    logo: json["logo"],
    title: json["title"],
    subtitle: json["subtitle"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    zoneName: json["zone_name"],
    departmentId: json["department_id"],
    totReview: json["tot_review"],
    avgStar: json["avg_star"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "title": title,
    "subtitle": subtitle,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "zone_name": zoneName,
    "department_id": departmentId,
    "tot_review": totReview,
    "avg_star": avgStar,
  };
}
