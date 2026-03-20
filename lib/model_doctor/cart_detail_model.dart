import 'dart:convert';

CartDetailModel cartDetailModelFromJson(String str) => CartDetailModel.fromJson(json.decode(str));

String cartDetailModelToJson(CartDetailModel data) => json.encode(data.toJson());

class CartDetailModel {
  int responseCode;
  bool result;
  String message;
  num walletAmount;
  num extraDoctorCharge;
  CommissionData commissionData;
  Doctor doctor;
  Hospital hospital;
  DepSubSerList depSubSerList;
  List<FamilyMember> familyMember;
  List<Coupon> coupon;

  CartDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.walletAmount,
    required this.extraDoctorCharge,
    required this.commissionData,
    required this.doctor,
    required this.hospital,
    required this.depSubSerList,
    required this.familyMember,
    required this.coupon,
  });

  factory CartDetailModel.fromJson(Map<String, dynamic> json) => CartDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    walletAmount: json["wallet_amount"],
    extraDoctorCharge: json["extra_doctor_charge"],
    commissionData: CommissionData.fromJson(json["commission_data"]),
    doctor: Doctor.fromJson(json["doctor"]),
    hospital: Hospital.fromJson(json["hospital"]),
    depSubSerList: DepSubSerList.fromJson(json["dep_sub_ser_list"]),
    familyMember: List<FamilyMember>.from(json["family_member"].map((x) => FamilyMember.fromJson(x))),
    coupon: List<Coupon>.from(json["coupon"].map((x) => Coupon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "wallet_amount": walletAmount,
    "extra_doctor_charge": extraDoctorCharge,
    "commission_data": commissionData.toJson(),
    "doctor": doctor.toJson(),
    "hospital": hospital.toJson(),
    "dep_sub_ser_list": depSubSerList.toJson(),
    "family_member": List<dynamic>.from(familyMember.map((x) => x.toJson())),
    "coupon": List<dynamic>.from(coupon.map((x) => x.toJson())),
  };
}

class CommissionData {
  String commissionRate;
  String commisiionType;

  CommissionData({
    required this.commissionRate,
    required this.commisiionType,
  });

  factory CommissionData.fromJson(Map<String, dynamic> json) => CommissionData(
    commissionRate: json["commission_rate"],
    commisiionType: json["commisiion_type"],
  );

  Map<String, dynamic> toJson() => {
    "commission_rate": commissionRate,
    "commisiion_type": commisiionType,
  };
}

class Coupon {
  int id;
  String doctorId;
  String title;
  String subTitle;
  String code;
  num minAmount;
  num discountAmount;
  String startDate;
  String endDate;

  Coupon({
    required this.id,
    required this.doctorId,
    required this.title,
    required this.subTitle,
    required this.code,
    required this.minAmount,
    required this.discountAmount,
    required this.startDate,
    required this.endDate,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"],
    doctorId: json["doctor_id"],
    title: json["title"],
    subTitle: json["sub_title"],
    code: json["code"],
    minAmount: json["min_amount"],
    discountAmount: json["discount_amount"],
    startDate: json["start_date"],
    endDate: json["end_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "doctor_id": doctorId,
    "title": title,
    "sub_title": subTitle,
    "code": code,
    "min_amount": minAmount,
    "discount_amount": discountAmount,
    "start_date": startDate,
    "end_date": endDate,
  };
}

class DepSubSerList {
  int id;
  String departmentName;
  String subTitle;
  String image;
  num clientVisitPrice;
  num videoConsultPrice;
  String showType;

  DepSubSerList({
    required this.id,
    required this.departmentName,
    required this.subTitle,
    required this.image,
    required this.clientVisitPrice,
    required this.videoConsultPrice,
    required this.showType,
  });

  factory DepSubSerList.fromJson(Map<String, dynamic> json) => DepSubSerList(
    id: json["id"],
    departmentName: json["department_name"],
    subTitle: json["sub_title"],
    image: json["image"],
    clientVisitPrice: json["client_visit_price"],
    videoConsultPrice: json["video_consult_price"],
    showType: json["show_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "department_name": departmentName,
    "sub_title": subTitle,
    "image": image,
    "client_visit_price": clientVisitPrice,
    "video_consult_price": videoConsultPrice,
    "show_type": showType,
  };
}

class Doctor {
  int id;
  String logo;
  String name;
  String countryCode;
  String phone;
  String address;
  String pincode;
  String landmark;
  num yearOfExperience;
  num totReview;
  num avgStar;

  Doctor({
    required this.id,
    required this.logo,
    required this.name,
    required this.countryCode,
    required this.phone,
    required this.address,
    required this.pincode,
    required this.landmark,
    required this.yearOfExperience,
    required this.totReview,
    required this.avgStar,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json["id"],
    logo: json["logo"],
    name: json["name"],
    countryCode: json["country_code"],
    phone: json["phone"],
    address: json["address"],
    pincode: json["pincode"],
    landmark: json["landmark"],
    yearOfExperience: json["year_of_experience"],
    totReview: json["tot_review"],
    avgStar: json["avg_star"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "name": name,
    "country_code": countryCode,
    "phone": phone,
    "address": address,
    "pincode": pincode,
    "landmark": landmark,
    "year_of_experience": yearOfExperience,
    "tot_review": totReview,
    "avg_star": avgStar,
  };
}

class FamilyMember {
  int id;
  String customerId;
  String profileImage;
  String name;
  String relationship;
  String bloodType;
  String gender;
  num patientAge;
  String nationalId;
  String height;
  String weight;
  String allergies;
  String medicalHistory;

  FamilyMember({
    required this.id,
    required this.customerId,
    required this.profileImage,
    required this.name,
    required this.relationship,
    required this.bloodType,
    required this.gender,
    required this.patientAge,
    required this.nationalId,
    required this.height,
    required this.weight,
    required this.allergies,
    required this.medicalHistory,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
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

class Hospital {
  int id;
  String image;
  String name;
  String email;
  String countryCode;
  String phone;
  String address;

  Hospital({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.address,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    email: json["email"],
    countryCode: json["country_code"],
    phone: json["phone"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "email": email,
    "country_code": countryCode,
    "phone": phone,
    "address": address,
  };
}
