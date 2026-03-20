// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));
String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  int? responseCode;
  bool? result;
  String? message;
  GeneralCurrency? generalCurrency;
  List<DepartmentList>? departmentList;
  List<BannerDatum>? bannerData;
  List<FamilyMember>? familyMember;
  List<FavDoctorList>? favDoctorList;
  List<DynamicList>? dynamicList;

  HomeModel({
    this.responseCode,
    this.result,
    this.message,
    this.generalCurrency,
    this.departmentList,
    this.bannerData,
    this.familyMember,
    this.favDoctorList,
    this.dynamicList,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        generalCurrency: json["general_currency"] == null
            ? null
            : GeneralCurrency.fromJson(json["general_currency"]),
        departmentList: json["department_list"] == null
            ? []
            : List<DepartmentList>.from(json["department_list"]!
                .map((x) => DepartmentList.fromJson(x))),
        bannerData: json["banner_data"] == null
            ? []
            : List<BannerDatum>.from(
                json["banner_data"]!.map((x) => BannerDatum.fromJson(x))),
        familyMember: json["family_member"] == null
            ? []
            : List<FamilyMember>.from(
                json["family_member"]!.map((x) => FamilyMember.fromJson(x))),
        favDoctorList: json["fav_doctor_list"] == null
            ? []
            : List<FavDoctorList>.from(
                json["fav_doctor_list"]!.map((x) => FavDoctorList.fromJson(x))),
        dynamicList: json["dynamic_list"] == null
            ? []
            : List<DynamicList>.from(
                json["dynamic_list"]!.map((x) => DynamicList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "general_currency": generalCurrency?.toJson(),
        "department_list":
            departmentList?.map((x) => x.toJson()).toList(),
        "banner_data": bannerData?.map((x) => x.toJson()).toList(),
        "family_member": familyMember?.map((x) => x.toJson()).toList(),
        "fav_doctor_list": favDoctorList?.map((x) => x.toJson()).toList(),
        "dynamic_list": dynamicList?.map((x) => x.toJson()).toList(),
      };
}

class GeneralCurrency {
  String? siteCurrency;
  String? oneAppId;
  String? oneAppIdReact;
  String? googleMapKey;
  String? agoraAppId;

  GeneralCurrency({
    this.siteCurrency,
    this.oneAppId,
    this.oneAppIdReact,
    this.googleMapKey,
    this.agoraAppId,
  });

  factory GeneralCurrency.fromJson(Map<String, dynamic> json) =>
      GeneralCurrency(
        siteCurrency: json["site_currency"],
        oneAppId: json["one_app_id"],
        oneAppIdReact: json["one_app_id_react"],
        googleMapKey: json["google_map_key"],
        agoraAppId: json["agora_app_id"],
      );

  Map<String, dynamic> toJson() => {
        "site_currency": siteCurrency,
        "one_app_id": oneAppId,
        "one_app_id_react": oneAppIdReact,
        "google_map_key": googleMapKey,
        "agora_app_id": agoraAppId,
      };
}

class DepartmentList {
  int? id;
  String? image;
  String? name;

  DepartmentList({this.id, this.image, this.name});

  factory DepartmentList.fromJson(Map<String, dynamic> json) =>
      DepartmentList(
        id: json["id"],
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
      };
}

class BannerDatum {
  int? id;
  String? image;
  String? department;
  String? title;
  String? subTitle;
  String? departmentName;

  BannerDatum({
    this.id,
    this.image,
    this.department,
    this.title,
    this.subTitle,
    this.departmentName,
  });

  factory BannerDatum.fromJson(Map<String, dynamic> json) => BannerDatum(
        id: json["id"],
        image: json["image"],
        department: json["department"],
        title: json["title"],
        subTitle: json["sub_title"],
        departmentName: json["department_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "department": department,
        "title": title,
        "sub_title": subTitle,
        "department_name": departmentName,
      };
}

class FamilyMember {
  int? id;
  String? profileImage;
  String? name;

  FamilyMember({this.id, this.profileImage, this.name});

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        id: json["id"],
        profileImage: json["profile_image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_image": profileImage,
        "name": name,
      };
}

class FavDoctorList {
  int? id;
  int? departmentId;
  String? logo;
  String? coverLogo;
  String? title;
  String? address;
  String? latitude;
  String? longitude;
  String? zoneName;
  num? totReview;
  num? avgStar;
  double? distanceKm;

  FavDoctorList({
    this.id,
    this.departmentId,
    this.logo,
    this.coverLogo,
    this.title,
    this.address,
    this.latitude,
    this.longitude,
    this.zoneName,
    this.totReview,
    this.avgStar,
    this.distanceKm,
  });

  factory FavDoctorList.fromJson(Map<String, dynamic> json) => FavDoctorList(
        id: json["id"],
        departmentId: json["department_id"],
        logo: json["logo"],
        coverLogo: json["cover_logo"],
        title: json["title"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        zoneName: json["zone_name"],
        totReview: json["tot_review"],
        avgStar: json["avg_star"],
        distanceKm: (json["distance_km"] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "department_id": departmentId,
        "logo": logo,
        "cover_logo": coverLogo,
        "title": title,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "zone_name": zoneName,
        "tot_review": totReview,
        "avg_star": avgStar,
        "distance_km": distanceKm,
      };
}

class DynamicList {
  int? id;
  String? title;
  String? module;
  String? category;
  String? name;
  List<DynamicDetails>? details;

  DynamicList({
    this.id,
    this.title,
    this.module,
    this.category,
    this.name,
    this.details,
  });

  factory DynamicList.fromJson(Map<String, dynamic> json) => DynamicList(
        id: json["id"],
        title: json["title"],
        module: json["module"],
        category: json["category"],
        name: json["name"],
        details: json["details"] == null
            ? []
            : List<DynamicDetails>.from(
                json["details"].map((x) => DynamicDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "module": module,
        "category": category,
        "name": name,
        "details": details?.map((x) => x.toJson()).toList(),
      };
}

class DynamicDetails {
  int? id;
  String? logo;
  String? name;
  String? zoneName;
  String? countryCode;
  String? phone;
  String? address;
  num? departmentId;
  double? distance;
  num? totReview;
  num? avgStar;

  DynamicDetails({
    this.id,
    this.logo,
    this.name,
    this.zoneName,
    this.countryCode,
    this.phone,
    this.address,
    this.departmentId,
    this.distance,
    this.totReview,
    this.avgStar,
  });

  factory DynamicDetails.fromJson(Map<String, dynamic> json) => DynamicDetails(
        id: json["id"],
        logo: json["logo"],
        name: json["name"],
        zoneName: json["zone_name"],
        countryCode: json["country_code"],
        phone: json["phone"],
        address: json["address"],
        departmentId: json["department_id"],
        distance: (json["distance"] ?? 0).toDouble(),
        totReview: json["tot_review"],
        avgStar: json["avg_star"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "name": name,
        "zone_name": zoneName,
        "country_code": countryCode,
        "phone": phone,
        "address": address,
        "department_id": departmentId,
        "distance": distance,
        "tot_review": totReview,
        "avg_star": avgStar,
      };
}
