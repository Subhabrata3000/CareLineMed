// To parse this JSON data, do
//
//     final faqListModel = faqListModelFromJson(jsonString);

import 'dart:convert';

FaqListModel faqListModelFromJson(String str) => FaqListModel.fromJson(json.decode(str));

String faqListModelToJson(FaqListModel data) => json.encode(data.toJson());

class FaqListModel {
    int? responseCode;
    bool? result;
    String? message;
    List<FaqList>? faqList;

    FaqListModel({
        this.responseCode,
        this.result,
        this.message,
        this.faqList,
    });

    factory FaqListModel.fromJson(Map<String, dynamic> json) => FaqListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        faqList: json["faq_list"] == null ? [] : List<FaqList>.from(json["faq_list"]!.map((x) => FaqList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "faq_list": faqList == null ? [] : List<dynamic>.from(faqList!.map((x) => x.toJson())),
    };
}

class FaqList {
    int? id;
    String? title;
    String? description;

    FaqList({
        this.id,
        this.title,
        this.description,
    });

    factory FaqList.fromJson(Map<String, dynamic> json) => FaqList(
        id: json["id"],
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
    };
}
