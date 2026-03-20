import 'dart:convert';

AddDoctorDetailModel addDoctorDetailModelFromJson(String str) => AddDoctorDetailModel.fromJson(json.decode(str));

String addDoctorDetailModelToJson(AddDoctorDetailModel data) => json.encode(data.toJson());

class AddDoctorDetailModel {
  int responseCode;
  bool result;
  String message;
  List<PList> bloodGroupList;
  List<PList> relationshipList;

  AddDoctorDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.bloodGroupList,
    required this.relationshipList,
  });

  factory AddDoctorDetailModel.fromJson(Map<String, dynamic> json) => AddDoctorDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    bloodGroupList: List<PList>.from(json["blood_group_list"].map((x) => PList.fromJson(x))),
    relationshipList: List<PList>.from(json["relationship_list"].map((x) => PList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "blood_group_list": List<dynamic>.from(bloodGroupList.map((x) => x.toJson())),
    "relationship_list": List<dynamic>.from(relationshipList.map((x) => x.toJson())),
  };
}

class PList {
  int id;
  String name;

  PList({
    required this.id,
    required this.name,
  });

  factory PList.fromJson(Map<String, dynamic> json) => PList(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
