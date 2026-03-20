// To parse this JSON data, do
//
//     final labListApiModel = labListApiModelFromJson(jsonString);

import 'dart:convert';

LabListApiModel labListApiModelFromJson(String str) => LabListApiModel.fromJson(json.decode(str));

String labListApiModelToJson(LabListApiModel data) => json.encode(data.toJson());

class LabListApiModel {
    int? responseCode;
    bool? result;
    String? message;
    List<LabList>? labList;

    LabListApiModel({
        this.responseCode,
        this.result,
        this.message,
        this.labList,
    });

    factory LabListApiModel.fromJson(Map<String, dynamic> json) => LabListApiModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        labList: json["lab_list"] == null ? [] : List<LabList>.from(json["lab_list"]!.map((x) => LabList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "lab_list": labList == null ? [] : List<dynamic>.from(labList!.map((x) => x.toJson())),
    };
}

class LabList {
    int? id;
    String? logo;
    String? name;
    String? address;
    double? distance;
    int? totReview;
    int? avgStar;

    LabList({
        this.id,
        this.logo,
        this.name,
        this.address,
        this.distance,
        this.totReview,
        this.avgStar,
    });

    factory LabList.fromJson(Map<String, dynamic> json) => LabList(
        id: json["id"],
        logo: json["logo"],
        name: json["name"],
        address: json["address"],
        distance: json["distance"]?.toDouble(),
        totReview: json["tot_review"],
        avgStar: json["avg_star"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "name": name,
        "address": address,
        "distance": distance,
        "tot_review": totReview,
        "avg_star": avgStar,
    };
}
