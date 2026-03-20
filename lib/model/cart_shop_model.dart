// To parse this JSON data, do
//
//     final cartShopModel = cartShopModelFromJson(jsonString);

import 'dart:convert';

CartShopModel cartShopModelFromJson(String str) => CartShopModel.fromJson(json.decode(str));

String cartShopModelToJson(CartShopModel data) => json.encode(data.toJson());

class CartShopModel {
    int? responseCode;
    bool? result;
    String? message;
    dynamic totPrice;
    List<Cplist>? cplist;

    CartShopModel({
        this.responseCode,
        this.result,
        this.message,
        this.totPrice,
        this.cplist,
    });

    factory CartShopModel.fromJson(Map<String, dynamic> json) => CartShopModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        totPrice: json["tot_price"],
        cplist: json["cplist"] == null ? [] : List<Cplist>.from(json["cplist"]!.map((x) => Cplist.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "tot_price": totPrice,
        "cplist": cplist == null ? [] : List<dynamic>.from(cplist!.map((x) => x.toJson())),
    };
}

class Cplist {
    int? id;
    String? productImage;
    String? productName;
    String? proType;
    String? prescriptionRequire;
    List<TotValue>? totValue;

    Cplist({
        this.id,
        this.productImage,
        this.productName,
        this.proType,
        this.prescriptionRequire,
        this.totValue,
    });

    factory Cplist.fromJson(Map<String, dynamic> json) => Cplist(
        id: json["id"],
        productImage: json["product_image"],
        productName: json["product_name"],
        proType: json["pro_type"],
        prescriptionRequire: json["prescription_require"],
        totValue: json["tot_value"] == null ? [] : List<TotValue>.from(json["tot_value"]!.map((x) => TotValue.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
        "product_name": productName,
        "pro_type": proType,
        "prescription_require": prescriptionRequire,
        "tot_value": totValue == null ? [] : List<dynamic>.from(totValue!.map((x) => x.toJson())),
    };
}

class TotValue {
    String? title;
    int? price;
    int? bprice;
    int? discount;
    int? qty;

    TotValue({
        this.title,
        this.price,
        this.bprice,
        this.discount,
        this.qty,
    });

    factory TotValue.fromJson(Map<String, dynamic> json) => TotValue(
        title: json["title"],
        price: json["price"],
        bprice: json["bprice"],
        discount: json["discount"],
        qty: json["qty"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "bprice": bprice,
        "discount": discount,
        "qty": qty,
    };
}
