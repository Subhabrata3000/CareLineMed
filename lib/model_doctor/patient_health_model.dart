import 'dart:convert';

PatientHealthModel patientHealthModelFromJson(String str) => PatientHealthModel.fromJson(json.decode(str));

String patientHealthModelToJson(PatientHealthModel data) => json.encode(data.toJson());

class PatientHealthModel {
  int responseCode;
  bool result;
  String message;
  String fmid;
  List<String> document;
  String healthConcern;

  PatientHealthModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.fmid,
    required this.document,
    required this.healthConcern,
  });

  factory PatientHealthModel.fromJson(Map<String, dynamic> json) => PatientHealthModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    fmid: json["fmid"],
    document: List<String>.from(json["document"].map((x) => x)),
    healthConcern: json["health_concern"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "fmid": fmid,
    "document": List<dynamic>.from(document.map((x) => x)),
    "health_concern": healthConcern,
  };
}
