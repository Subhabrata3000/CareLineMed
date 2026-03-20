// To parse this JSON data, do
//
//     final packgeDetailApiModel = packgeDetailApiModelFromJson(jsonString);

import 'dart:convert';

PackgeDetailApiModel packgeDetailApiModelFromJson(String str) => PackgeDetailApiModel.fromJson(json.decode(str));

String packgeDetailApiModelToJson(PackgeDetailApiModel data) => json.encode(data.toJson());

class PackgeDetailApiModel {
    int? responseCode;
    bool? result;
    String? message;
    PackageData? packageData;

    PackgeDetailApiModel({
        this.responseCode,
        this.result,
        this.message,
        this.packageData,
    });

    factory PackgeDetailApiModel.fromJson(Map<String, dynamic> json) => PackgeDetailApiModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        packageData: json["package_data"] == null ? null : PackageData.fromJson(json["package_data"]),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "package_data": packageData?.toJson(),
    };
}

class PackageData {
    int? id;
    String? logo;
    String? title;
    String? subtitle;
    String? description;
    int? homeExtraPrice;
    String? fastingRequire;
    String? testReportTime;
    List<String>? sampleType;
    String? packageType;
    List<String>? packageName;
    List<int>? packagePrice;
    int? totPrice;

    PackageData({
        this.id,
        this.logo,
        this.title,
        this.subtitle,
        this.description,
        this.homeExtraPrice,
        this.fastingRequire,
        this.testReportTime,
        this.sampleType,
        this.packageType,
        this.packageName,
        this.packagePrice,
        this.totPrice,
    });

    factory PackageData.fromJson(Map<String, dynamic> json) => PackageData(
        id: json["id"],
        logo: json["logo"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        homeExtraPrice: json["home_extra_price"],
        fastingRequire: json["fasting_require"],
        testReportTime: json["test_report_time"],
        sampleType: json["sample_type"] == null ? [] : List<String>.from(json["sample_type"]!.map((x) => x)),
        packageType: json["package_type"],
        packageName: json["package_name"] == null ? [] : List<String>.from(json["package_name"]!.map((x) => x)),
        packagePrice: json["package_price"] == null ? [] : List<int>.from(json["package_price"]!.map((x) => x)),
        totPrice: json["tot_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "home_extra_price": homeExtraPrice,
        "fasting_require": fastingRequire,
        "test_report_time": testReportTime,
        "sample_type": sampleType == null ? [] : List<dynamic>.from(sampleType!.map((x) => x)),
        "package_type": packageType,
        "package_name": packageName == null ? [] : List<dynamic>.from(packageName!.map((x) => x)),
        "package_price": packagePrice == null ? [] : List<dynamic>.from(packagePrice!.map((x) => x)),
        "tot_price": totPrice,
    };
}
