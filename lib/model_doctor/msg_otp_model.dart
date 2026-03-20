
import 'dart:convert';

MsgOtpModel msgOtpModelFromJson(String str) => MsgOtpModel.fromJson(json.decode(str));

String msgOtpModelToJson(MsgOtpModel data) => json.encode(data.toJson());

class MsgOtpModel {
  int responseCode;
  bool result;
  String message;
  String otp;

  MsgOtpModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.otp,
  });

  factory MsgOtpModel.fromJson(Map<String, dynamic> json) => MsgOtpModel(
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
