import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  int responseCode;
  bool result;
  String message;
  List<CategoryList> categoryList;

  CategoryModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.categoryList,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    categoryList: List<CategoryList>.from(json["category_list"].map((x) => CategoryList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "category_list": List<dynamic>.from(categoryList.map((x) => x.toJson())),
  };
}

class CategoryList {
  int id;
  String image;
  String name;

  CategoryList({
    required this.id,
    required this.image,
    required this.name,
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
