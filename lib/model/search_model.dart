// To parse this JSON data, do
//
//     final searchModel = searchModelFromJson(jsonString);

import 'dart:convert';

SearchModel searchModelFromJson(String str) => SearchModel.fromJson(json.decode(str));

String searchModelToJson(SearchModel data) => json.encode(data.toJson());

class SearchModel {
  int? responseCode;
  bool? result;
  String? message;
  List<DoctorList>? doctorList;

  SearchModel({
    this.responseCode,
    this.result,
    this.message,
    this.doctorList,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        doctorList: json["doctor_list"] == null
            ? []
            : List<DoctorList>.from(
                json["doctor_list"]!.map((x) => DoctorList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "doctor_list": doctorList == null
            ? []
            : List<dynamic>.from(doctorList!.map((x) => x.toJson())),
      };
}

class DoctorList {
  int? id;
  String? logo;
  String? name;
  String? title;
  String? subtitle;
  int? totFavorite;
  double? distance;
  int? totReview;
  int? avgStar;

  DoctorList({
    this.id,
    this.logo,
    this.name,
    this.title,
    this.subtitle,
    this.totFavorite,
    this.distance,
    this.totReview,
    this.avgStar,
  });

  factory DoctorList.fromJson(Map<String, dynamic> json) => DoctorList(
        id: json["id"],
        logo: json["logo"],
        name: json["name"],
        title: json["title"],
        subtitle: json["subtitle"],
        totFavorite: json["tot_favorite"],
        distance: (json["distance"] as num?)?.toDouble(),
        totReview: json["tot_review"],
        avgStar: json["avg_star"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "name": name,
        "title": title,
        "subtitle": subtitle,
        "tot_favorite": totFavorite,
        "distance": distance,
        "tot_review": totReview,
        "avg_star": avgStar,
      };
}
