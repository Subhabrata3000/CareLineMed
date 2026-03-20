// To parse this JSON data, do
//
//     final notificationListApiModel = notificationListApiModelFromJson(jsonString);

import 'dart:convert';

NotificationListApiModel notificationListApiModelFromJson(String str) => NotificationListApiModel.fromJson(json.decode(str));

String notificationListApiModelToJson(NotificationListApiModel data) => json.encode(data.toJson());

class NotificationListApiModel {
    int? responseCode;
    bool? result;
    String? message;
    List<Nlist>? nlist;

    NotificationListApiModel({
        this.responseCode,
        this.result,
        this.message,
        this.nlist,
    });

    factory NotificationListApiModel.fromJson(Map<String, dynamic> json) => NotificationListApiModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        nlist: json["nlist"] == null ? [] : List<Nlist>.from(json["nlist"]!.map((x) => Nlist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "nlist": nlist == null ? [] : List<dynamic>.from(nlist!.map((x) => x.toJson())),
    };
}

class Nlist {
    int? id;
    String? orderId;
    String? customerId;
    String? serviceUserId;
    String? date;
    String? mstatus;
    String? ostatus;
    String? notification;
    String? serviceUname;

    Nlist({
        this.id,
        this.orderId,
        this.customerId,
        this.serviceUserId,
        this.date,
        this.mstatus,
        this.ostatus,
        this.notification,
        this.serviceUname,
    });

    factory Nlist.fromJson(Map<String, dynamic> json) => Nlist(
        id: json["id"],
        orderId: json["order_id"],
        customerId: json["customer_id"],
        serviceUserId: json["service_user_id"],
        date: json["date"],
        mstatus: json["mstatus"],
        ostatus: json["ostatus"],
        notification: json["notification"],
        serviceUname: json["service_uname"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "customer_id": customerId,
        "service_user_id": serviceUserId,
        "date": date,
        "mstatus": mstatus,
        "ostatus": ostatus,
        "notification": notification,
        "service_uname": serviceUname,
    };
}
