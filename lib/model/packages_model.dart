// To parse this JSON data, do
//
//     final packagesApiModel = packagesApiModelFromJson(jsonString);

import 'dart:convert';

PackagesApiModel packagesApiModelFromJson(String str) => PackagesApiModel.fromJson(json.decode(str));

String packagesApiModelToJson(PackagesApiModel data) => json.encode(data.toJson());

class PackagesApiModel {
    int? responseCode;
    bool? result;
    String? message;
    int? cartCheck;
    List<Individual>? individual;
    List<Individual>? package;

    PackagesApiModel({
        this.responseCode,
        this.result,
        this.message,
        this.cartCheck,
        this.individual,
        this.package,
    });

    factory PackagesApiModel.fromJson(Map<String, dynamic> json) => PackagesApiModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        cartCheck: json["cart_check"],
        individual: json["individual"] == null ? [] : List<Individual>.from(json["individual"]!.map((x) => Individual.fromJson(x))),
        package: json["package"] == null ? [] : List<Individual>.from(json["package"]!.map((x) => Individual.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "cart_check": cartCheck,
        "individual": individual == null ? [] : List<dynamic>.from(individual!.map((x) => x.toJson())),
        "package": package == null ? [] : List<dynamic>.from(package!.map((x) => x.toJson())),
    };
}

class Individual {
    int? id;
    String? logo;
    String? title;
    String? fastingRequire;
    String? testReportTime;
    int? packageName;
    int? packagePrice;
    String? packageType;
    int? exist;

    Individual({
        this.id,
        this.logo,
        this.title,
        this.fastingRequire,
        this.testReportTime,
        this.packageName,
        this.packagePrice,
        this.packageType,
        this.exist,
    });

    factory Individual.fromJson(Map<String, dynamic> json) => Individual(
        id: json["id"],
        logo: json["logo"],
        title: json["title"],
        fastingRequire: json["fasting_require"],
        testReportTime: json["test_report_time"],
        packageName: json["package_name"],
        packagePrice: json["package_price"],
        packageType: json["package_type"],
        exist: json["exist"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "title": title,
        "fasting_require": fastingRequire,
        "test_report_time": testReportTime,
        "package_name": packageName,
        "package_price": packagePrice,
        "package_type": packageType,
        "exist": exist,
    };
}
