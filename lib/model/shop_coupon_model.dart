// To parse this JSON data, do
//
//     final shopCouponModel = shopCouponModelFromJson(jsonString);

import 'dart:convert';

ShopCouponModel shopCouponModelFromJson(String str) => ShopCouponModel.fromJson(json.decode(str));

String shopCouponModelToJson(ShopCouponModel data) => json.encode(data.toJson());

class ShopCouponModel {
    int? responseCode;
    bool? result;
    String? message;
    List<CouponList>? couponList;

    ShopCouponModel({
        this.responseCode,
        this.result,
        this.message,
        this.couponList,
    });

    factory ShopCouponModel.fromJson(Map<String, dynamic> json) => ShopCouponModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        couponList: json["coupon_list"] == null ? [] : List<CouponList>.from(json["coupon_list"]!.map((x) => CouponList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "coupon_list": couponList == null ? [] : List<dynamic>.from(couponList!.map((x) => x.toJson())),
    };
}

class CouponList {
    int? id;
    String? doctorId;
    String? title;
    String? subTitle;
    String? code;
    num? minAmount;
    num? discountAmount;
    DateTime? startDate;
    DateTime? endDate;

    CouponList({
        this.id,
        this.doctorId,
        this.title,
        this.subTitle,
        this.code,
        this.minAmount,
        this.discountAmount,
        this.startDate,
        this.endDate,
    });

    factory CouponList.fromJson(Map<String, dynamic> json) => CouponList(
        id: json["id"],
        doctorId: json["doctor_id"],
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
        "doctor_id": doctorId,
        "title": title,
        "sub_title": subTitle,
        "code": code,
        "min_amount": minAmount,
        "discount_amount": discountAmount,
        "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    };
}
