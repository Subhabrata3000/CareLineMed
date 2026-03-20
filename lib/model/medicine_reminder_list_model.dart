// To parse this JSON data, do
//
//     final medicineReminderListModel = medicineReminderListModelFromJson(jsonString);

import 'dart:convert';

MedicineReminderListModel medicineReminderListModelFromJson(String str) =>
    MedicineReminderListModel.fromJson(json.decode(str));

String medicineReminderListModelToJson(MedicineReminderListModel data) =>
    json.encode(data.toJson());

class MedicineReminderListModel {
  int? responseCode;
  bool? result;
  String? message;
  List<RemiderList>? remiderList;

  MedicineReminderListModel({
    this.responseCode,
    this.result,
    this.message,
    this.remiderList,
  });

  factory MedicineReminderListModel.fromJson(Map<String, dynamic> json) =>
      MedicineReminderListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        remiderList: json["remider_list"] == null
            ? []
            : List<RemiderList>.from(
                json["remider_list"]!.map((x) => RemiderList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "remider_list": remiderList == null
            ? []
            : List<dynamic>.from(remiderList!.map((x) => x.toJson())),
      };
}

class RemiderList {
  int? id;
  String? customerId;
  String? medicineName;
  List<Map<String, dynamic>>? time;
  String? status;

  RemiderList({
    this.id,
    this.customerId,
    this.medicineName,
    this.time,
    this.status,
  });

  factory RemiderList.fromJson(Map<String, dynamic> json) => RemiderList(
        id: json["id"],
        customerId: json["customer_id"],
        medicineName: json["medicine_name"],
        time: json["time"] == null
            ? []
            : List<Map<String, dynamic>>.from(
                json["time"]!.map((x) => Map<String, dynamic>.from(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "medicine_name": medicineName,
        "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
        "status": status,
      };
}