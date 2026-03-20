import 'dart:convert';

OtpGetModel otpGetModelFromJson(String str) => OtpGetModel.fromJson(json.decode(str));

String otpGetModelToJson(OtpGetModel data) => json.encode(data.toJson());

class OtpGetModel {
  int responseCode;
  bool result;
  String message;

  OtpGetModel({
    required this.responseCode,
    required this.result,
    required this.message,
  });

  factory OtpGetModel.fromJson(Map<String, dynamic> json) => OtpGetModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
  };
}
