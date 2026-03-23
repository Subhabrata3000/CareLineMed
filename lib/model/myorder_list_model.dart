// To parse this JSON data, do
//
//     final myOrderListModel = myOrderListModelFromJson(jsonString);

import 'dart:convert';

MyOrderListModel myOrderListModelFromJson(String str) => MyOrderListModel.fromJson(json.decode(str));

String myOrderListModelToJson(MyOrderListModel data) => json.encode(data.toJson());

class MyOrderListModel {
    int? responseCode;
    bool? result;
    String? message;
    List<Complete>? running;
    List<Complete>? complete;

    MyOrderListModel({
        this.responseCode,
        this.result,
        this.message,
        this.running,
        this.complete,
    });

    factory MyOrderListModel.fromJson(Map<String, dynamic> json) => MyOrderListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        running: json["running"] == null ? [] : List<Complete>.from(json["running"]!.map((x) => Complete.fromJson(x))),
        complete: json["complete"] == null ? [] : List<Complete>.from(json["complete"]!.map((x) => Complete.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "running": running == null ? [] : List<dynamic>.from(running!.map((x) => x.toJson())),
        "complete": complete == null ? [] : List<dynamic>.from(complete!.map((x) => x.toJson())),
    };
}

class Complete {
    int? id;
    String? doctorId;
    String? status;
    num? totPrice;
    String? date;
    int? totProduct;
    String? image;
    String? name;
    String? address;

    Complete({
        this.id,
        this.doctorId,
        this.status,
        this.totPrice,
        this.date,
        this.totProduct,
        this.image,
        this.name,
        this.address,
    });

    factory Complete.fromJson(Map<String, dynamic> json) => Complete(
        id: json["id"],
        doctorId: json["doctor_id"],
        status: json["status"],
        totPrice: json["tot_price"],
        date: json["date"],
        totProduct: json["tot_product"],
        image: json["image"],
        name: json["name"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "status": status,
        "tot_price": totPrice,
        "date": date,
        "tot_product": totProduct,
        "image": image,
        "name": name,
        "address": address,
    };
}
