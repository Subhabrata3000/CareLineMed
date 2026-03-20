// To parse this JSON data, do
//
//     final searchMeditineListModel = searchMeditineListModelFromJson(jsonString);

import 'dart:convert';

SearchMeditineListModel searchMeditineListModelFromJson(String str) => SearchMeditineListModel.fromJson(json.decode(str));

String searchMeditineListModelToJson(SearchMeditineListModel data) => json.encode(data.toJson());

class SearchMeditineListModel {
    int? responseCode;
    bool? result;
    String? message;
    List<String>? medicine;

    SearchMeditineListModel({
        this.responseCode,
        this.result,
        this.message,
        this.medicine,
    });

    factory SearchMeditineListModel.fromJson(Map<String, dynamic> json) => SearchMeditineListModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        medicine: json["medicine"] == null ? [] : List<String>.from(json["medicine"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "medicine": medicine == null ? [] : List<dynamic>.from(medicine!.map((x) => x)),
    };
}
