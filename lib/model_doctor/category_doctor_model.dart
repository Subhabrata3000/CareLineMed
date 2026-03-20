import 'dart:convert';

CategoryTypeDoctorModel categoryTypeDoctorModelFromJson(String str) => CategoryTypeDoctorModel.fromJson(json.decode(str));

String categoryTypeDoctorModelToJson(CategoryTypeDoctorModel data) => json.encode(data.toJson());

class CategoryTypeDoctorModel {
  int responseCode;
  bool result;
  String message;
  List<ClinicVisit> clinicVisit;
  List<ClinicVisit> videoConsult;

  CategoryTypeDoctorModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.clinicVisit,
    required this.videoConsult,
  });

  factory CategoryTypeDoctorModel.fromJson(Map<String, dynamic> json) => CategoryTypeDoctorModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    clinicVisit: List<ClinicVisit>.from(json["clinic_visit"].map((x) => ClinicVisit.fromJson(x))),
    videoConsult: List<ClinicVisit>.from(json["video_consult"].map((x) => ClinicVisit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "clinic_visit": List<dynamic>.from(clinicVisit.map((x) => x.toJson())),
    "video_consult": List<dynamic>.from(videoConsult.map((x) => x.toJson())),
  };
}

class ClinicVisit {
  String id;
  String logo;
  String title;
  String subtitle;
  num yearOfExperience;
  num minInpPrice;
  num maxInpPrice;
  num minVidPrice;
  num maxVidPrice;
  String latitude;
  String longitude;
  String zoneName;
  num totReview;
  num avgStar;
  num distanceKm;

  ClinicVisit({
    required this.id,
    required this.logo,
    required this.title,
    required this.subtitle,
    required this.yearOfExperience,
    required this.minInpPrice,
    required this.maxInpPrice,
    required this.minVidPrice,
    required this.maxVidPrice,
    required this.latitude,
    required this.longitude,
    required this.zoneName,
    required this.totReview,
    required this.avgStar,
    required this.distanceKm,
  });

  factory ClinicVisit.fromJson(Map<String, dynamic> json) => ClinicVisit(
    id: json["id"],
    logo: json["logo"],
    title: json["title"],
    subtitle: json["subtitle"],
    yearOfExperience: json["year_of_experience"],
    minInpPrice: json["min_inp_price"],
    maxInpPrice: json["max_inp_price"],
    minVidPrice: json["min_vid_price"],
    maxVidPrice: json["max_vid_price"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    zoneName: json["zone_name"],
    totReview: json["tot_review"],
    avgStar: json["avg_star"],
    distanceKm: json["distance_km"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "title": title,
    "subtitle": subtitle,
    "year_of_experience": yearOfExperience,
    "min_inp_price": minInpPrice,
    "max_inp_price": maxInpPrice,
    "min_vid_price": minVidPrice,
    "max_vid_price": maxVidPrice,
    "latitude": latitude,
    "longitude": longitude,
    "zone_name": zoneName,
    "tot_review": totReview,
    "avg_star": avgStar,
    "distance_km": distanceKm,
  };
}
