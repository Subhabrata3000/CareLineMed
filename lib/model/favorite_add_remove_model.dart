import 'dart:convert';

FavoriteAddRemoveModel favoriteAddRemoveModelFromJson(String str) => FavoriteAddRemoveModel.fromJson(json.decode(str));

String favoriteAddRemoveModelToJson(FavoriteAddRemoveModel data) => json.encode(data.toJson());

class FavoriteAddRemoveModel {
  String message;
  bool status;

  FavoriteAddRemoveModel({
    required this.message,
    required this.status,
  });

  factory FavoriteAddRemoveModel.fromJson(Map<String, dynamic> json) => FavoriteAddRemoveModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
