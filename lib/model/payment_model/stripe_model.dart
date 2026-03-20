import 'dart:convert';

StripeModel stripeModelFromJson(String str) => StripeModel.fromJson(json.decode(str));

String stripeModelToJson(StripeModel data) => json.encode(data.toJson());

class StripeModel {
  String message;
  bool status;
  String stripeUrl;

  StripeModel({
    required this.message,
    required this.status,
    required this.stripeUrl,
  });

  factory StripeModel.fromJson(Map<String, dynamic> json) => StripeModel(
    message: json["message"],
    status: json["status"],
    stripeUrl: json["StripeURL"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "StripeURL": stripeUrl,
  };
}
