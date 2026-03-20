// To parse this JSON data, do
//
//     final checkOutModel = checkOutModelFromJson(jsonString);

import 'dart:convert';

CheckOutModel checkOutModelFromJson(String str) => CheckOutModel.fromJson(json.decode(str));

String checkOutModelToJson(CheckOutModel data) => json.encode(data.toJson());

class CheckOutModel {
    int? responseCode;
    bool? result;
    String? message;
    num? walletAmount;
    num? totPrice;
    ComData? comData;
    List<ProductList>? productList;

    CheckOutModel({
        this.responseCode,
        this.result,
        this.message,
        this.walletAmount,
        this.totPrice,
        this.comData,
        this.productList,
    });

    factory CheckOutModel.fromJson(Map<String, dynamic> json) => CheckOutModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        walletAmount: json["wallet_amount"],
        totPrice: json["tot_price"],
        comData: json["com_data"] == null ? null : ComData.fromJson(json["com_data"]),
        productList: json["product_list"] == null ? [] : List<ProductList>.from(json["product_list"]!.map((x) => ProductList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "wallet_amount": walletAmount,
        "tot_price": totPrice,
        "com_data": comData?.toJson(),
        "product_list": productList == null ? [] : List<dynamic>.from(productList!.map((x) => x.toJson())),
    };
}

class ComData {
    String? commissionRate;
    String? commisiionType;

    ComData({
        this.commissionRate,
        this.commisiionType,
    });

    factory ComData.fromJson(Map<String, dynamic> json) => ComData(
        commissionRate: json["commission_rate"],
        commisiionType: json["commisiion_type"],
    );

    Map<String, dynamic> toJson() => {
        "commission_rate": commissionRate,
        "commisiion_type": commisiionType,
    };
}

class ProductList {
    int? id;
    String? productImage;
    String? productName;
    String? proType;
    String? prescriptionRequire;
    List<PriceDetail>? priceDetail;

    ProductList({
        this.id,
        this.productImage,
        this.productName,
        this.proType,
        this.prescriptionRequire,
        this.priceDetail,
    });

    factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        id: json["id"],
        productImage: json["product_image"],
        productName: json["product_name"],
        proType: json["pro_type"],
        prescriptionRequire: json["prescription_require"],
        priceDetail: json["price_detail"] == null ? [] : List<PriceDetail>.from(json["price_detail"]!.map((x) => PriceDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
        "product_name": productName,
        "pro_type": proType,
        "prescription_require": prescriptionRequire,
        "price_detail": priceDetail == null ? [] : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
    };
}

class PriceDetail {
    String? title;
    num? price;
    num? basePrice;
    num? discount;
    num? cartQty;

    PriceDetail({
        this.title,
        this.price,
        this.basePrice,
        this.discount,
        this.cartQty,
    });

    factory PriceDetail.fromJson(Map<String, dynamic> json) => PriceDetail(
        title: json["title"],
        price: json["price"],
        basePrice: json["base_price"],
        discount: json["discount"],
        cartQty: json["cart_qty"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "base_price": basePrice,
        "discount": discount,
        "cart_qty": cartQty,
    };
}
