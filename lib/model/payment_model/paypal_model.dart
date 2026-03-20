import 'dart:convert';

PaypalModel paypalModelFromJson(String str) => PaypalModel.fromJson(json.decode(str));

String paypalModelToJson(PaypalModel data) => json.encode(data.toJson());

class PaypalModel {
  String message;
  bool status;
  String paypalUrl;

  PaypalModel({
    required this.message,
    required this.status,
    required this.paypalUrl,
  });

  factory PaypalModel.fromJson(Map<String, dynamic> json) => PaypalModel(
    message: json["message"],
    status: json["status"],
    paypalUrl: json["paypalURL"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "paypalURL": paypalUrl,
  };
}
