// To parse this JSON data, do
//
//     final appintCancelResonListModel = appintCancelResonListModelFromJson(jsonString);

import 'dart:convert';

AppintCancelResonListModel appintCancelResonListModelFromJson(String str) =>
    AppintCancelResonListModel.fromJson(json.decode(str));

String appintCancelResonListModelToJson(AppintCancelResonListModel data) =>
    json.encode(data.toJson());

class AppintCancelResonListModel {
  int? responseCode;
  bool? result;
  String? message;
  List<CancelReason>? cancelReason;

  AppintCancelResonListModel({
    this.responseCode,
    this.result,
    this.message,
    this.cancelReason,
  });

  factory AppintCancelResonListModel.fromJson(Map<String, dynamic> json) =>
      AppintCancelResonListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        cancelReason: json["cancel_reason"] == null
            ? []
            : List<CancelReason>.from(
                json["cancel_reason"]!.map((x) => CancelReason.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "cancel_reason": cancelReason == null
            ? []
            : List<dynamic>.from(cancelReason!.map((x) => x.toJson())),
      };
}

class CancelReason {
  int? id;
  String? title;

  CancelReason({
    this.id,
    this.title,
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
