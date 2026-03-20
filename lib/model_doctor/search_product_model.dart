// To parse this JSON data, do
//
//     final productSearchModel = productSearchModelFromJson(jsonString);

import 'dart:convert';

ProductSearchModel productSearchModelFromJson(String str) => ProductSearchModel.fromJson(json.decode(str));

String productSearchModelToJson(ProductSearchModel data) => json.encode(data.toJson());

class ProductSearchModel {
    int? responseCode;
    bool? result;
    String? message;
    List<ProductList>? productList;

    ProductSearchModel({
        this.responseCode,
        this.result,
        this.message,
        this.productList,
    });

    factory ProductSearchModel.fromJson(Map<String, dynamic> json) => ProductSearchModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        productList: json["product_list"] == null ? [] : List<ProductList>.from(json["product_list"]!.map((x) => ProductList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "product_list": productList == null ? [] : List<dynamic>.from(productList!.map((x) => x.toJson())),
    };
}

class ProductList {
    int? id;
    String? productImage;
    String? productName;
    List<PriceDetail>? priceDetail;

    ProductList({
        this.id,
        this.productImage,
        this.productName,
        this.priceDetail,
    });

    factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        id: json["id"],
        productImage: json["product_image"],
        productName: json["product_name"],
        priceDetail: json["price_detail"] == null ? [] : List<PriceDetail>.from(json["price_detail"]!.map((x) => PriceDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_image": productImage,
        "product_name": productName,
        "price_detail": priceDetail == null ? [] : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
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
