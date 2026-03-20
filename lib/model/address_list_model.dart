// To parse this JSON data, do
//
//     final addressListModel = addressListModelFromJson(jsonString);

import 'dart:convert';

AddressListModel addressListModelFromJson(String str) => AddressListModel.fromJson(json.decode(str));

String addressListModelToJson(AddressListModel data) => json.encode(data.toJson());

class AddressListModel {
    int? responseCode;
    bool? result;
    String? message;
    List<AddressList>? addressList;

    AddressListModel({
        this.responseCode,
        this.result,
        this.message,
        this.addressList,
    });

    factory AddressListModel.fromJson(Map<String, dynamic> json) => AddressListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        addressList: json["address_list"] == null ? [] : List<AddressList>.from(json["address_list"]!.map((x) => AddressList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "address_list": addressList == null ? [] : List<dynamic>.from(addressList!.map((x) => x.toJson())),
    };
}

class AddressList {
    int? id;
    String? customerId;
    String? houseNo;
    String? address;
    String? landmark;
    String? addressAs;
    String? countryCode;
    String? phone;
    String? latitude;
    String? longitude;
    String? googleAddress;
    String? instruction;

    AddressList({
        this.id,
        this.customerId,
        this.houseNo,
        this.address,
        this.landmark,
        this.addressAs,
        this.countryCode,
        this.phone,
        this.latitude,
        this.longitude,
        this.googleAddress,
        this.instruction,
    });

    factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        id: json["id"],
        customerId: json["customer_id"],
        houseNo: json["house_no"],
        address: json["address"],
        landmark: json["landmark"],
        addressAs: json["address_as"],
        countryCode: json["country_code"],
        phone: json["phone"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        googleAddress: json["google_address"],
        instruction: json["instruction"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "house_no": houseNo,
        "address": address,
        "landmark": landmark,
        "address_as": addressAs,
        "country_code": countryCode,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude,
        "google_address": googleAddress,
        "instruction": instruction,
    };
}