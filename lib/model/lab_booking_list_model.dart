// To parse this JSON data, do
//
//     final labBookingListModel = labBookingListModelFromJson(jsonString);

import 'dart:convert';

LabBookingListModel labBookingListModelFromJson(String str) => LabBookingListModel.fromJson(json.decode(str));

String labBookingListModelToJson(LabBookingListModel data) => json.encode(data.toJson());

class LabBookingListModel {
    int? responseCode;
    bool? result;
    String? message;
    List<LabList>? labPendingList;
    List<LabList>? labCompleteList;

    LabBookingListModel({
        this.responseCode,
        this.result,
        this.message,
        this.labPendingList,
        this.labCompleteList,
    });

    factory LabBookingListModel.fromJson(Map<String, dynamic> json) => LabBookingListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        labPendingList: json["lab_pending_list"] == null ? [] : List<LabList>.from(json["lab_pending_list"]!.map((x) => LabList.fromJson(x))),
        labCompleteList: json["lab_complete_list"] == null ? [] : List<LabList>.from(json["lab_complete_list"]!.map((x) => LabList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "lab_pending_list": labPendingList == null ? [] : List<dynamic>.from(labPendingList!.map((x) => x.toJson())),
        "lab_complete_list": labCompleteList == null ? [] : List<dynamic>.from(labCompleteList!.map((x) => x.toJson())),
    };
}

class LabList {
    int? id;
    String? date;
    num? totPrice;
    String? status;
    String? labLogo;
    String? name;
    String? countryCode;
    String? phone;
    String? statusType;

    LabList({
        this.id,
        this.date,
        this.totPrice,
        this.status,
        this.labLogo,
        this.name,
        this.countryCode,
        this.phone,
        this.statusType,
    });

    factory LabList.fromJson(Map<String, dynamic> json) => LabList(
        id: json["id"],
        date: json["date"],
        totPrice: json["tot_price"],
        status: json["status"],
        labLogo: json["lab_logo"],
        name: json["name"],
        countryCode: json["country_code"],
        phone: json["phone"],
        statusType: json["status_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "tot_price": totPrice,
        "status": status,
        "lab_logo": labLogo,
        "name": name,
        "country_code": countryCode,
        "phone": phone,
        "status_type": statusType,
    };
}
