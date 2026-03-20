// To parse this JSON data, do
//
//     final referEarnModel = referEarnModelFromJson(jsonString);

import 'dart:convert';

ReferEarnModel referEarnModelFromJson(String str) => ReferEarnModel.fromJson(json.decode(str));

String referEarnModelToJson(ReferEarnModel data) => json.encode(data.toJson());

class ReferEarnModel {
    int? responseCode;
    bool? result;
    String? message;
    FererralData? fererralData;

    ReferEarnModel({
        this.responseCode,
        this.result,
        this.message,
        this.fererralData,
    });

    factory ReferEarnModel.fromJson(Map<String, dynamic> json) => ReferEarnModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        fererralData: json["fererral_data"] == null ? null : FererralData.fromJson(json["fererral_data"]),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "fererral_data": fererralData?.toJson(),
    };
}

class FererralData {
    String? referralCode;
    int? signupCredit;
    int? referCredit;

    FererralData({
        this.referralCode,
        this.signupCredit,
        this.referCredit,
    });

    factory FererralData.fromJson(Map<String, dynamic> json) => FererralData(
        referralCode: json["referral_code"],
        signupCredit: json["signup_credit"],
        referCredit: json["refer_credit"],
    );

    Map<String, dynamic> toJson() => {
        "referral_code": referralCode,
        "signup_credit": signupCredit,
        "refer_credit": referCredit,
    };
}
