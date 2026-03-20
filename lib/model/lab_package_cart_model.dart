// To parse this JSON data, do
//
//     final labPackageCartApiModel = labPackageCartApiModelFromJson(jsonString);

import 'dart:convert';

LabPackageCartApiModel labPackageCartApiModelFromJson(String str) => LabPackageCartApiModel.fromJson(json.decode(str));

String labPackageCartApiModelToJson(LabPackageCartApiModel data) => json.encode(data.toJson());

class LabPackageCartApiModel {
    int? responseCode;
    bool? result;
    String? message;
    num? walletAmount;
    num? homeExtraPrice;
    CommissionData? commissionData;
    Lab? lab;
    Category? category;
    List<PackageDetail>? packageDetail;
    List<FamilyMember>? familyMember;
    List<Coupon>? coupon;

    LabPackageCartApiModel({
        this.responseCode,
        this.result,
        this.message,
        this.walletAmount,
        this.homeExtraPrice,
        this.commissionData,
        this.lab,
        this.category,
        this.packageDetail,
        this.familyMember,
        this.coupon,
    });

    factory LabPackageCartApiModel.fromJson(Map<String, dynamic> json) => LabPackageCartApiModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        walletAmount: json["wallet_amount"],
        homeExtraPrice: json["home_extra_price"],
        commissionData: json["commission_data"] == null ? null : CommissionData.fromJson(json["commission_data"]),
        lab: json["lab"] == null ? null : Lab.fromJson(json["lab"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        packageDetail: json["package_detail"] == null ? [] : List<PackageDetail>.from(json["package_detail"]!.map((x) => PackageDetail.fromJson(x))),
        familyMember: json["family_member"] == null ? [] : List<FamilyMember>.from(json["family_member"]!.map((x) => FamilyMember.fromJson(x))),
        coupon: json["coupon"] == null ? [] : List<Coupon>.from(json["coupon"]!.map((x) => Coupon.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "wallet_amount": walletAmount,
        "home_extra_price": homeExtraPrice,
        "commission_data": commissionData?.toJson(),
        "lab": lab?.toJson(),
        "category": category?.toJson(),
        "package_detail": packageDetail == null ? [] : List<dynamic>.from(packageDetail!.map((x) => x.toJson())),
        "family_member": familyMember == null ? [] : List<dynamic>.from(familyMember!.map((x) => x.toJson())),
        "coupon": coupon == null ? [] : List<dynamic>.from(coupon!.map((x) => x.toJson())),
    };
}

class Category {
    int? id;
    String? image;
    String? name;

    Category({
        this.id,
        this.image,
        this.name,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        image: json["image"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
    };
}

class CommissionData {
    String? commissionRate;
    String? commisiionType;

    CommissionData({
        this.commissionRate,
        this.commisiionType,
    });

    factory CommissionData.fromJson(Map<String, dynamic> json) => CommissionData(
        commissionRate: json["commission_rate"],
        commisiionType: json["commisiion_type"],
    );

    Map<String, dynamic> toJson() => {
        "commission_rate": commissionRate,
        "commisiion_type": commisiionType,
    };
}

class Coupon {
    int? id;
    String? title;
    String? subTitle;
    String? code;
    num? minAmount;
    num? discountAmount;
    DateTime? startDate;
    DateTime? endDate;

    Coupon({
        this.id,
        this.title,
        this.subTitle,
        this.code,
        this.minAmount,
        this.discountAmount,
        this.startDate,
        this.endDate,
    });

    factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
        code: json["code"],
        minAmount: json["min_amount"],
        discountAmount: json["discount_amount"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_title": subTitle,
        "code": code,
        "min_amount": minAmount,
        "discount_amount": discountAmount,
        "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    };
}

class FamilyMember {
    int? id;
    String? customerId;
    String? profileImage;
    String? name;
    String? relationship;
    String? bloodType;
    String? gender;
    num? patientAge;
    String? nationalId;
    String? height;
    String? weight;
    String? allergies;
    String? medicalHistory;

    FamilyMember({
        this.id,
        this.customerId,
        this.profileImage,
        this.name,
        this.relationship,
        this.bloodType,
        this.gender,
        this.patientAge,
        this.nationalId,
        this.height,
        this.weight,
        this.allergies,
        this.medicalHistory,
    });

    factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json["id"],
        customerId: json["customer_id"],
        profileImage: json["profile_image"],
        name: json["name"],
        relationship: json["relationship"],
        bloodType: json["blood_type"],
        gender: json["gender"],
        patientAge: json["patient_age"],
        nationalId: json["national_id"],
        height: json["height"],
        weight: json["weight"],
        allergies: json["allergies"],
        medicalHistory: json["medical_history"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "profile_image": profileImage,
        "name": name,
        "relationship": relationship,
        "blood_type": bloodType,
        "gender": gender,
        "patient_age": patientAge,
        "national_id": nationalId,
        "height": height,
        "weight": weight,
        "allergies": allergies,
        "medical_history": medicalHistory,
    };
}

class Lab {
    int? id;
    String? logo;
    String? name;
    String? licenseNumber;
    String? address;
    num? totReview;
    num? avgStar;

    Lab({
        this.id,
        this.logo,
        this.name,
        this.licenseNumber,
        this.address,
        this.totReview,
        this.avgStar,
    });

    factory Lab.fromJson(Map<String, dynamic> json) => Lab(
        id: json["id"],
        logo: json["logo"],
        name: json["name"],
        licenseNumber: json["license_number"],
        address: json["address"],
        totReview: json["tot_review"],
        avgStar: json["avg_star"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "name": name,
        "license_number": licenseNumber,
        "address": address,
        "tot_review": totReview,
        "avg_star": avgStar,
    };
}

class PackageDetail {
    int? id;
    String? logo;
    String? title;
    String? subtitle;
    String? description;
    num? homeExtraPrice;
    String? fastingRequire;
    String? testReportTime;
    List<String>? sampleType;
    num? packageName;
    num? packagePrice;

    PackageDetail({
        this.id,
        this.logo,
        this.title,
        this.subtitle,
        this.description,
        this.homeExtraPrice,
        this.fastingRequire,
        this.testReportTime,
        this.sampleType,
        this.packageName,
        this.packagePrice,
    });

    factory PackageDetail.fromJson(Map<String, dynamic> json) => PackageDetail(
        id: json["id"],
        logo: json["logo"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        homeExtraPrice: json["home_extra_price"],
        fastingRequire: json["fasting_require"],
        testReportTime: json["test_report_time"],
        sampleType: json["sample_type"] == null ? [] : List<String>.from(json["sample_type"]!.map((x) => x)),
        packageName: json["package_name"],
        packagePrice: json["package_price"],
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
        "package_name": packageName,
        "package_price": packagePrice,
    };
}
