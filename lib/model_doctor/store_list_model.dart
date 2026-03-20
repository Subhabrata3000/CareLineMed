// To parse this JSON data, do
//
//     final storeListModel = storeListModelFromJson(jsonString);

import 'dart:convert';

StoreListModel storeListModelFromJson(String str) => StoreListModel.fromJson(json.decode(str));

String storeListModelToJson(StoreListModel data) => json.encode(data.toJson());

class StoreListModel {
    int? responseCode;
    bool? result;
    String? message;
    List<StoreList>? storeList;

    StoreListModel({
        this.responseCode,
        this.result,
        this.message,
        this.storeList,
    });

    factory StoreListModel.fromJson(Map<String, dynamic> json) => StoreListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        storeList: json["store_list"] == null ? [] : List<StoreList>.from(json["store_list"]!.map((x) => StoreList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "store_list": storeList == null ? [] : List<dynamic>.from(storeList!.map((x) => x.toJson())),
    };
}

class StoreList {
    int? id;
    String? image;
    String? name;
    String? address;
    String? latitude;
    String? longitude;

    StoreList({
        this.id,
        this.image,
        this.name,
        this.address,
        this.latitude,
        this.longitude,
    });

    factory StoreList.fromJson(Map<String, dynamic> json) => StoreList(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
    };
}
