// To parse this JSON data, do
//
//     final familyMemberDetailModel = familyMemberDetailModelFromJson(jsonString);

import 'dart:convert';

FamilyMemberDetailModel familyMemberDetailModelFromJson(String str) => FamilyMemberDetailModel.fromJson(json.decode(str));

String familyMemberDetailModelToJson(FamilyMemberDetailModel data) => json.encode(data.toJson());

class FamilyMemberDetailModel {
    int? responseCode;
    bool? result;
    String? message;
    Data? data;

    FamilyMemberDetailModel({
        this.responseCode,
        this.result,
        this.message,
        this.data,
    });

    factory FamilyMemberDetailModel.fromJson(Map<String, dynamic> json) => FamilyMemberDetailModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? customerId;
    String? profileImage;
    String? name;
    String? relationship;
    String? bloodType;
    String? gender;
    int? patientAge;
    String? nationalId;
    String? height;
    String? weight;
    String? allergies;
    String? medicalHistory;

    Data({
        this.id,
        this.customerId,
        this.profileImage,
        this.name,
        this.relationship,
        this.bloodType,
        this.gender,
        this.patientAge,
        this.nationalId,
        this.height,
        this.weight,
        this.allergies,
        this.medicalHistory,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        customerId: json["customer_id"],
        profileImage: json["profile_image"],
        name: json["name"],
        relationship: json["relationship"],
        bloodType: json["blood_type"],
        gender: json["gender"],
        patientAge: json["patient_age"],
        nationalId: json["national_id"],
        height: json["height"],
        weight: json["weight"],
        allergies: json["allergies"],
        medicalHistory: json["medical_history"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "profile_image": profileImage,
        "name": name,
        "relationship": relationship,
        "blood_type": bloodType,
        "gender": gender,
        "patient_age": patientAge,
        "national_id": nationalId,
        "height": height,
        "weight": weight,
        "allergies": allergies,
        "medical_history": medicalHistory,
    };
}
