// To parse this JSON data, do
//
//     final productListModel = productListModelFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

class ProductListModel {
    int? responseCode;
    bool? result;
    String? message;
    int? totCartQty;
    List<ProductList>? productList;

    ProductListModel({
        this.responseCode,
        this.result,
        this.message,
        this.totCartQty,
        this.productList,
    });

    factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        totCartQty: json["tot_cart_qty"],
        productList: json["product_list"] == null ? [] : List<ProductList>.from(json["product_list"]!.map((x) => ProductList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "tot_cart_qty": totCartQty,
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


// import 'dart:convert';

// ProductListModel productListModelFromJson(String str) => ProductListModel.fromJson(json.decode(str));

// String productListModelToJson(ProductListModel data) => json.encode(data.toJson());

// class ProductListModel {
//   int responseCode;
//   bool result;
//   String message;
//   List<ProductList> productList;

//   ProductListModel({
//     required this.responseCode,
//     required this.result,
//     required this.message,
//     required this.productList,
//   });

//   factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
//     responseCode: json["ResponseCode"],
//     result: json["Result"],
//     message: json["message"],
//     productList: List<ProductList>.from(json["product_list"].map((x) => ProductList.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "ResponseCode": responseCode,
//     "Result": result,
//     "message": message,
//     "product_list": List<dynamic>.from(productList.map((x) => x.toJson())),
//   };
// }

// class ProductList {
//   int id;
//   String productImage;
//   String productName;
//   dynamic price;
//   String priceTitle;

//   ProductList({
//     required this.id,
//     required this.productImage,
//     required this.productName,
//     required this.price,
//     required this.priceTitle,
//   });

//   factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
//     id: json["id"],
//     productImage: json["product_image"],
//     productName: json["product_name"],
//     price: json["price"],
//     priceTitle: json["price_title"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "product_image": productImage,
//     "product_name": productName,
//     "price": price,
//     "price_title": priceTitle,
//   };
// }
