// To parse this JSON data, do
//
//     final appointmentDiagnosisModel = appointmentDiagnosisModelFromJson(jsonString);

import 'dart:convert';

AppointmentDiagnosisModel appointmentDiagnosisModelFromJson(String str) => AppointmentDiagnosisModel.fromJson(json.decode(str));

String appointmentDiagnosisModelToJson(AppointmentDiagnosisModel data) => json.encode(data.toJson());

class AppointmentDiagnosisModel {
  int responseCode;
  bool result;
  String message;
  List<Appoint> appoint;

  AppointmentDiagnosisModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.appoint,
  });

  factory AppointmentDiagnosisModel.fromJson(Map<String, dynamic> json) => AppointmentDiagnosisModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    appoint: List<Appoint>.from(json["appoint"].map((x) => Appoint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "appoint": List<dynamic>.from(appoint.map((x) => x.toJson())),
  };
}

class Appoint {
  int id;
  String name;
  String description;

  Appoint({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Appoint.fromJson(Map<String, dynamic> json) => Appoint(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
