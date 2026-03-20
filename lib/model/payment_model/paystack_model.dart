import 'dart:convert';

PayStackModel payStackModelFromJson(String str) => PayStackModel.fromJson(json.decode(str));

String payStackModelToJson(PayStackModel data) => json.encode(data.toJson());

class PayStackModel {
  String message;
  bool status;
  String paystackUrl;

  PayStackModel({
    required this.message,
    required this.status,
    required this.paystackUrl,
  });

  factory PayStackModel.fromJson(Map<String, dynamic> json) => PayStackModel(
    message: json["message"],
    status: json["status"],
    paystackUrl: json["PaystackURL"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "PaystackURL": paystackUrl,
  };
}
