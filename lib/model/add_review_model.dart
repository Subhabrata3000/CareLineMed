import 'dart:convert';

AddReviewModel addReviewModelFromJson(String str) => AddReviewModel.fromJson(json.decode(str));

String addReviewModelToJson(AddReviewModel data) => json.encode(data.toJson());

class AddReviewModel {
  bool status;
  String message;

  AddReviewModel({
    required this.status,
    required this.message,
  });

  factory AddReviewModel.fromJson(Map<String, dynamic> json) => AddReviewModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
