import 'dart:convert';

CancelOrderModel cancelOrderModelFromJson(String str) => CancelOrderModel.fromJson(json.decode(str));

String cancelOrderModelToJson(CancelOrderModel data) => json.encode(data.toJson());

class CancelOrderModel {
  int responseCode;
  bool result;
  String message;
  List<CancelReason> cancelReason;

  CancelOrderModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.cancelReason,
  });

  factory CancelOrderModel.fromJson(Map<String, dynamic> json) => CancelOrderModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    cancelReason: List<CancelReason>.from(json["cancel_reason"].map((x) => CancelReason.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "cancel_reason": List<dynamic>.from(cancelReason.map((x) => x.toJson())),
  };
}

class CancelReason {
  int id;
  String title;

  CancelReason({
    required this.id,
    required this.title,
  });

  factory CancelReason.fromJson(Map<String, dynamic> json) => CancelReason(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
