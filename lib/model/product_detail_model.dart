// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

ProductDetailModel productDetailModelFromJson(String str) => ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) => json.encode(data.toJson());

class ProductDetailModel {
    int? responseCode;
    bool? result;
    String? message;
    int? totCartQty;
    Product? product;

    ProductDetailModel({
        this.responseCode,
        this.result,
        this.message,
        this.totCartQty,
        this.product,
    });

    factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        totCartQty: json["tot_cart_qty"],
        product: json["product"] == null ? null : Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "tot_cart_qty": totCartQty,
        "product": product?.toJson(),
    };
}

class Product {
    int? id;
    List<String>? productImage;
    String? productName;
    String? description;
    List<PriceDetail>? priceDetail;
    String? status;
    String? proType;
    String? prescriptionRequire;
    String? serviceName;
    String? subserName;

    Product({
        this.id,
        this.productImage,
        this.productName,
        this.description,
        this.priceDetail,
        this.status,
        this.proType,
        this.prescriptionRequire,
        this.serviceName,
        this.subserName,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productImage: json["product_image"] == null ? [] : List<String>.from(json["product_image"]!.map((x) => x)),
        productName: json["product_name"],
        description: json["description"],
        priceDetail: json["price_detail"] == null ? [] : List<PriceDetail>.from(json["price_detail"]!.map((x) => PriceDetail.fromJson(x))),
        status: json["status"],
        proType: json["pro_type"],
        prescriptionRequire: json["prescription_require"],
        serviceName: json["service_name"],
        subserName: json["subser_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage == null ? [] : List<dynamic>.from(productImage!.map((x) => x)),
        "product_name": productName,
        "description": description,
        "price_detail": priceDetail == null ? [] : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
        "status": status,
        "pro_type": proType,
        "prescription_require": prescriptionRequire,
        "service_name": serviceName,
        "subser_name": subserName,
    };
}

class PriceDetail {
    int? price;
    String? title;
    int? discount;
    int? basePrice;
    int? cartQty;

    PriceDetail({
        this.price,
        this.title,
        this.discount,
        this.basePrice,
        this.cartQty,
    });

    factory PriceDetail.fromJson(Map<String, dynamic> json) => PriceDetail(
        price: json["price"],
        title: json["title"],
        discount: json["discount"],
        basePrice: json["base_price"],
        cartQty: json["cart_qty"],
    );

    Map<String, dynamic> toJson() => {
        "price": price,
        "title": title,
        "discount": discount,
        "base_price": basePrice,
        "cart_qty": cartQty,
    };
}
