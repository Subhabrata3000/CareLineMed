
import 'dart:convert';

TwilioOtpModel twilioOtpModelFromJson(String str) => TwilioOtpModel.fromJson(json.decode(str));

String twilioOtpModelToJson(TwilioOtpModel data) => json.encode(data.toJson());

class TwilioOtpModel {
  int responseCode;
  bool result;
  String message;
  String otp;

  TwilioOtpModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.otp,
  });

  factory TwilioOtpModel.fromJson(Map<String, dynamic> json) => TwilioOtpModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "otp": otp,
  };
}
