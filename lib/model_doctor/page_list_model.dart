import 'dart:convert';

PageListModel pageListModelFromJson(String str) => PageListModel.fromJson(json.decode(str));

String pageListModelToJson(PageListModel data) => json.encode(data.toJson());

class PageListModel {
  int responseCode;
  bool result;
  String message;
  List<PagesDatum> pagesData;

  PageListModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.pagesData,
  });

  factory PageListModel.fromJson(Map<String, dynamic> json) => PageListModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    pagesData: List<PagesDatum>.from(json["pages_data"].map((x) => PagesDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "pages_data": List<dynamic>.from(pagesData.map((x) => x.toJson())),
  };
}

class PagesDatum {
  int id;
  String title;
  String status;
  String description;

  PagesDatum({
    required this.id,
    required this.title,
    required this.status,
    required this.description,
  });

  factory PagesDatum.fromJson(Map<String, dynamic> json) => PagesDatum(
    id: json["id"],
    title: json["title"],
    status: json["status"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
    "description": description,
  };
}
