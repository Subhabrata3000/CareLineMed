// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    int? responseCode;
    bool? result;
    String? message;
    List<String>? bannerList;
    List<SubCategory>? subCategory;

    ProductModel({
        this.responseCode,
        this.result,
        this.message,
        this.bannerList,
        this.subCategory,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        bannerList: json["banner_list"] == null ? [] : List<String>.from(json["banner_list"]!.map((x) => x)),
        subCategory: json["sub_category"] == null ? [] : List<SubCategory>.from(json["sub_category"]!.map((x) => SubCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "banner_list": bannerList == null ? [] : List<dynamic>.from(bannerList!.map((x) => x)),
        "sub_category": subCategory == null ? [] : List<dynamic>.from(subCategory!.map((x) => x.toJson())),
    };
}

class SubCategory {
    int? id;
    String? categoryName;
    String? name;
    String? image;

    SubCategory({
        this.id,
        this.categoryName,
        this.name,
        this.image,
    });

    factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        categoryName: json["category_name"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "name": name,
        "image": image,
    };
}
