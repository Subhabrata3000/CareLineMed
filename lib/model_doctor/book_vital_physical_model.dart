import 'dart:convert';

BookVitalPhysicalModel bookVitalPhysicalModelFromJson(String str) => BookVitalPhysicalModel.fromJson(json.decode(str));

String bookVitalPhysicalModelToJson(BookVitalPhysicalModel data) => json.encode(data.toJson());

class BookVitalPhysicalModel {
  int responseCode;
  bool result;
  String message;
  List<VitPhyList> vitPhyList;

  BookVitalPhysicalModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.vitPhyList,
  });

  factory BookVitalPhysicalModel.fromJson(Map<String, dynamic> json) => BookVitalPhysicalModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    vitPhyList: List<VitPhyList>.from(json["vit_phy_list"].map((x) => VitPhyList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "vit_phy_list": List<dynamic>.from(vitPhyList.map((x) => x.toJson())),
  };
}

class VitPhyList {
  int id;
  String title;
  String text;

  VitPhyList({
    required this.id,
    required this.title,
    required this.text,
  });

  factory VitPhyList.fromJson(Map<String, dynamic> json) => VitPhyList(
    id: json["id"],
    title: json["title"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
  };
}
