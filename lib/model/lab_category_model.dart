// To parse this JSON data, do
//
//     final labCategoryApiModel = labCategoryApiModelFromJson(jsonString);

import 'dart:convert';

LabCategoryApiModel labCategoryApiModelFromJson(String str) => LabCategoryApiModel.fromJson(json.decode(str));

String labCategoryApiModelToJson(LabCategoryApiModel data) => json.encode(data.toJson());

class LabCategoryApiModel {
    int? responseCode;
    bool? result;
    String? message;
    List<String>? bannerList;
    List<CategoryList>? categoryList;

    LabCategoryApiModel({
        this.responseCode,
        this.result,
        this.message,
        this.bannerList,
        this.categoryList,
    });

    factory LabCategoryApiModel.fromJson(Map<String, dynamic> json) => LabCategoryApiModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        bannerList: json["banner_list"] == null ? [] : List<String>.from(json["banner_list"]!.map((x) => x)),
        categoryList: json["category_list"] == null ? [] : List<CategoryList>.from(json["category_list"]!.map((x) => CategoryList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "banner_list": bannerList == null ? [] : List<dynamic>.from(bannerList!.map((x) => x)),
        "category_list": categoryList == null ? [] : List<dynamic>.from(categoryList!.map((x) => x.toJson())),
    };
}

class CategoryList {
    int? id;
    String? image;
    String? name;

    CategoryList({
        this.id,
        this.image,
        this.name,
    });

    factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        image: json["image"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
    };
}
