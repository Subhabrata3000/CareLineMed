import 'dart:convert';

AppointmentDetailModel appointmentDetailModelFromJson(String str) =>
    AppointmentDetailModel.fromJson(json.decode(str));

String appointmentDetailModelToJson(AppointmentDetailModel data) =>
    json.encode(data.toJson());

class AppointmentDetailModel {
  int? responseCode;
  bool? result;
  String? message;
  Appoint? appoint;
  Doctor? doctor;
  Sebservice? sebservice;
  Hospital? hospital;
  List<FamilyMember>? familyMember;

  AppointmentDetailModel({
    this.responseCode,
    this.result,
    this.message,
    this.appoint,
    this.doctor,
    this.sebservice,
    this.hospital,
    this.familyMember,
  });

  factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        appoint: json["appoint"] == null ? null : Appoint.fromJson(json["appoint"]),
        doctor: json["doctor"] == null ? null : Doctor.fromJson(json["doctor"]),
        sebservice: json["sebservice"] == null
            ? null
            : Sebservice.fromJson(json["sebservice"]),
        hospital:
            json["hospital"] == null ? null : Hospital.fromJson(json["hospital"]),
        familyMember: json["family_member"] == null
            ? []
            : List<FamilyMember>.from(json["family_member"].map((x) => FamilyMember.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "appoint": appoint?.toJson(),
        "doctor": doctor?.toJson(),
        "sebservice": sebservice?.toJson(),
        "hospital": hospital?.toJson(),
        "family_member": familyMember == null ? [] : familyMember!.map((x) => x.toJson()).toList(),
      };
}

class Appoint {
  int? id;
  String? customerId;
  String? doctorId;
  String? hospitalId;
  String? departmentId;
  String? subDeparId;
  String? status;
  String? bookDate;
  String? appointmentDate;
  String? appointmentTime;
  String? dateType;
  String? familyMemId;
  String? showType;
  double? showTypePrice;
  double? totPrice;
  double? paidAmount;
  num? additionalPrice;
  String? couponId;
  double? couponAmount;
  double? doctorCommission;
  num? siteCommisiion;
  num? walletAmount;
  num? onlineAmount;
  num? cashAmount;
  String? paymentId;
  String? paymentName;
  String? paymentImage;
  String? additionalNote;
  num? vitalsPhysical;
  num? drugsPrescription;
  num? diagnosisTest;
  num? reviewCheck;
  num? timecount;
  String? cancelTitle;
  String? cancelReason;
  String? transactionId;
  num? otp;
  String? qrcode;

  Appoint({
    this.id,
    this.customerId,
    this.doctorId,
    this.hospitalId,
    this.departmentId,
    this.subDeparId,
    this.status,
    this.bookDate,
    this.appointmentDate,
    this.appointmentTime,
    this.dateType,
    this.familyMemId,
    this.showType,
    this.showTypePrice,
    this.totPrice,
    this.paidAmount,
    this.additionalPrice,
    this.couponId,
    this.couponAmount,
    this.doctorCommission,
    this.siteCommisiion,
    this.walletAmount,
    this.onlineAmount,
    this.cashAmount,
    this.paymentId,
    this.paymentName,
    this.paymentImage,
    this.additionalNote,
    this.vitalsPhysical,
    this.drugsPrescription,
    this.diagnosisTest,
    this.reviewCheck,
    this.timecount,
    this.cancelTitle,
    this.cancelReason,
    this.transactionId,
    this.otp,
    this.qrcode,
  });

  factory Appoint.fromJson(Map<String, dynamic> json) => Appoint(
        id: json["id"],
        customerId: json["customer_id"],
        doctorId: json["doctor_id"],
        hospitalId: json["hospital_id"],
        departmentId: json["department_id"],
        subDeparId: json["sub_depar_id"],
        status: json["status"],
        bookDate: json["book_date"],
        appointmentDate: json["appointment_date"],
        appointmentTime: json["appointment_time"],
        dateType: json["date_type"],
        familyMemId: json["family_mem_id"],
        showType: json["show_type"],
        showTypePrice: json["show_type_price"]?.toDouble(),
        totPrice: json["tot_price"]?.toDouble(),
        paidAmount: json["paid_amount"]?.toDouble(),
        additionalPrice: json["additional_price"],
        couponId: json["coupon_id"],
        couponAmount: json["coupon_amount"]?.toDouble(),
        doctorCommission: json["doctor_commission"]?.toDouble(),
        siteCommisiion: json["site_commisiion"],
        walletAmount: json["wallet_amount"],
        onlineAmount: json["online_amount"],
        cashAmount: json["cash_amount"],
        paymentId: json["payment_id"],
        paymentName: json["payment_name"],
        paymentImage: json["payment_image"],
        additionalNote: json["additional_note"],
        vitalsPhysical: json["vitals_physical"],
        drugsPrescription: json["drugs_prescription"],
        diagnosisTest: json["diagnosis_test"],
        reviewCheck: json["review_check"],
        timecount: json["timecount"],
        cancelTitle: json["cancel_title"],
        cancelReason: json["cancel_reason"],
        transactionId: json["transactionId"],
        otp: json["otp"],
        qrcode: json["qrcode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "doctor_id": doctorId,
        "hospital_id": hospitalId,
        "department_id": departmentId,
        "sub_depar_id": subDeparId,
        "status": status,
        "book_date": bookDate,
        "appointment_date": appointmentDate,
        "appointment_time": appointmentTime,
        "date_type": dateType,
        "family_mem_id": familyMemId,
        "show_type": showType,
        "show_type_price": showTypePrice,
        "tot_price": totPrice,
        "paid_amount": paidAmount,
        "additional_price": additionalPrice,
        "coupon_id": couponId,
        "coupon_amount": couponAmount,
        "doctor_commission": doctorCommission,
        "site_commisiion": siteCommisiion,
        "wallet_amount": walletAmount,
        "online_amount": onlineAmount,
        "cash_amount": cashAmount,
        "payment_id": paymentId,
        "payment_name": paymentName,
        "payment_image": paymentImage,
        "additional_note": additionalNote,
        "vitals_physical": vitalsPhysical,
        "drugs_prescription": drugsPrescription,
        "diagnosis_test": diagnosisTest,
        "review_check": reviewCheck,
        "timecount": timecount,
        "cancel_title": cancelTitle,
        "cancel_reason": cancelReason,
        "transactionId": transactionId,
        "otp": otp,
        "qrcode": qrcode,
      };
}

class Doctor {
  int? id;
  String? logo;
  String? name;
  String? countryCode;
  String? phone;
  String? address;
  String? pincode;
  String? landmark;
  num? yearOfExperience;
  num? totReview;
  num? avgStar;

  Doctor({
    this.id,
    this.logo,
    this.name,
    this.countryCode,
    this.phone,
    this.address,
    this.pincode,
    this.landmark,
    this.yearOfExperience,
    this.totReview,
    this.avgStar,
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

class Sebservice {
  int? id;
  String? departImage;
  String? departmentName;
  String? subTitle;
  String? image;
  num? clientVisitPrice;
  num? videoConsultPrice;
  String? showType;

  Sebservice({
    this.id,
    this.departImage,
    this.departmentName,
    this.subTitle,
    this.image,
    this.clientVisitPrice,
    this.videoConsultPrice,
    this.showType,
  });

  factory Sebservice.fromJson(Map<String, dynamic> json) => Sebservice(
        id: json["id"],
        departImage: json["depart_image"],
        departmentName: json["department_name"],
        subTitle: json["sub_title"],
        image: json["image"],
        clientVisitPrice: json["client_visit_price"],
        videoConsultPrice: json["video_consult_price"],
        showType: json["show_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "depart_image": departImage,
        "department_name": departmentName,
        "sub_title": subTitle,
        "image": image,
        "client_visit_price": clientVisitPrice,
        "video_consult_price": videoConsultPrice,
        "show_type": showType,
      };
}

class Hospital {
  int? id;
  String? image;
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  String? address;
  String? latitude;
  String? longitude;

  Hospital({
    this.id,
    this.image,
    this.name,
    this.email,
    this.countryCode,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        email: json["email"],
        countryCode: json["country_code"],
        phone: json["phone"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "email": email,
        "country_code": countryCode,
        "phone": phone,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class FamilyMember {
  int? id;
  String? customerId;
  String? profileImage;
  String? name;
  String? relationship;
  String? bloodType;
  String? gender;
  num? patientAge;
  String? nationalId;
  String? height;
  String? weight;
  String? allergies;
  String? medicalHistory;

  FamilyMember({
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


// import 'dart:convert';

// AppointmentDetailModel appointmentDetailModelFromJson(String str) => AppointmentDetailModel.fromJson(json.decode(str));

// String appointmentDetailModelToJson(AppointmentDetailModel data) => json.encode(data.toJson());

// class AppointmentDetailModel {
//   int responseCode;
//   bool result;
//   String message;
//   Appoint appoint;
//   Doctor doctor;
//   Sebservice sebservice;
//   Hospital hospital;
//   List<FamilyMember> familyMember;

//   AppointmentDetailModel({
//     required this.responseCode,
//     required this.result,
//     required this.message,
//     required this.appoint,
//     required this.doctor,
//     required this.sebservice,
//     required this.hospital,
//     required this.familyMember,
//   });

//   factory AppointmentDetailModel.fromJson(Map<String, dynamic> json) => AppointmentDetailModel(
//     responseCode: json["ResponseCode"],
//     result: json["Result"],
//     message: json["message"],
//     appoint: Appoint.fromJson(json["appoint"]),
//     doctor: Doctor.fromJson(json["doctor"]),
//     sebservice: Sebservice.fromJson(json["sebservice"]),
//     hospital: Hospital.fromJson(json["hospital"]),
//     familyMember: List<FamilyMember>.from(json["family_member"].map((x) => FamilyMember.fromJson(x))),
//   );

//   Map<String, dynamic> toJson() => {
//     "ResponseCode": responseCode,
//     "Result": result,
//     "message": message,
//     "appoint": appoint.toJson(),
//     "doctor": doctor.toJson(),
//     "sebservice": sebservice.toJson(),
//     "hospital": hospital.toJson(),
//     "family_member": List<dynamic>.from(familyMember.map((x) => x.toJson())),
//   };
// }

// class Appoint {
//   int id;
//   String customerId;
//   String doctorId;
//   String hospitalId;
//   String departmentId;
//   String subDeparId;
//   String status;
//   String bookDate;
//   String appointmentDate;
//   String appointmentTime;
//   String dateType;
//   String familyMemId;
//   String showType;
//   int showTypePrice;
//   num totPrice;
//   num paidAmount;
//   num additionalPrice;
//   String couponId;
//   num couponAmount;
//   num doctorCommission;
//   num siteCommisiion;
//   String paymentId;
//   num walletAmount;
//   String additionalNote;
//   String paymentImage;
//   String paymentName;
//   num onlineAmount;
//   int vitalsPhysical;
//   int drugsPrescription;
//   int diagnosisTest;
//   String reviewCheck;
//   num timecount;
//   int otp;
//   String qrcode;

//   Appoint({
//     required this.id,
//     required this.customerId,
//     required this.doctorId,
//     required this.hospitalId,
//     required this.departmentId,
//     required this.subDeparId,
//     required this.status,
//     required this.bookDate,
//     required this.appointmentDate,
//     required this.appointmentTime,
//     required this.dateType,
//     required this.familyMemId,
//     required this.showType,
//     required this.showTypePrice,
//     required this.totPrice,
//     required this.paidAmount,
//     required this.additionalPrice,
//     required this.couponId,
//     required this.couponAmount,
//     required this.doctorCommission,
//     required this.siteCommisiion,
//     required this.paymentId,
//     required this.walletAmount,
//     required this.additionalNote,
//     required this.paymentImage,
//     required this.paymentName,
//     required this.onlineAmount,
//     required this.vitalsPhysical,
//     required this.drugsPrescription,
//     required this.diagnosisTest,
//     required this.reviewCheck,
//     required this.timecount,
//     required this.otp,
//     required this.qrcode,
//   });

//   factory Appoint.fromJson(Map<String, dynamic> json) => Appoint(
//     id: json["id"],
//     customerId: json["customer_id"],
//     doctorId: json["doctor_id"],
//     hospitalId: json["hospital_id"],
//     departmentId: json["department_id"],
//     subDeparId: json["sub_depar_id"],
//     status: json["status"],
//     bookDate: json["book_date"],
//     appointmentDate: json["appointment_date"],
//     appointmentTime: json["appointment_time"],
//     dateType: json["date_type"],
//     familyMemId: json["family_mem_id"],
//     showType: json["show_type"],
//     showTypePrice: json["show_type_price"],
//     totPrice: json["tot_price"],
//     paidAmount: json["paid_amount"],
//     additionalPrice: json["additional_price"],
//     couponId: json["coupon_id"],
//     couponAmount: json["coupon_amount"],
//     doctorCommission: json["doctor_commission"],
//     siteCommisiion: json["site_commisiion"],
//     paymentId: json["payment_id"],
//     walletAmount: json["wallet_amount"],
//     additionalNote: json["additional_note"],
//     paymentImage: json["payment_image"],
//     paymentName: json["payment_name"],
//     onlineAmount: json["online_amount"],
//     vitalsPhysical: json["vitals_physical"],
//     drugsPrescription: json["drugs_prescription"],
//     diagnosisTest: json["diagnosis_test"],
//     reviewCheck: json["review_check"],
//     timecount: json["timecount"],
//     otp: json["otp"],
//     qrcode: json["qrcode"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "customer_id": customerId,
//     "doctor_id": doctorId,
//     "hospital_id": hospitalId,
//     "department_id": departmentId,
//     "sub_depar_id": subDeparId,
//     "status": status,
//     "book_date": bookDate,
//     "appointment_date": appointmentDate,
//     "appointment_time": appointmentTime,
//     "date_type": dateType,
//     "family_mem_id": familyMemId,
//     "show_type": showType,
//     "show_type_price": showTypePrice,
//     "tot_price": totPrice,
//     "paid_amount": paidAmount,
//     "additional_price": additionalPrice,
//     "coupon_id": couponId,
//     "coupon_amount": couponAmount,
//     "doctor_commission": doctorCommission,
//     "site_commisiion": siteCommisiion,
//     "payment_id": paymentId,
//     "wallet_amount": walletAmount,
//     "additional_note": additionalNote,
//     "payment_image": paymentImage,
//     "payment_name": paymentName,
//     "online_amount": onlineAmount,
//     "vitals_physical": vitalsPhysical,
//     "drugs_prescription": drugsPrescription,
//     "diagnosis_test": diagnosisTest,
//     "review_check": reviewCheck,
//     "timecount": timecount,
//     "otp": otp,
//     "qrcode": qrcode,
//   };
// }

// class Doctor {
//   int id;
//   String logo;
//   String name;
//   String countryCode;
//   String phone;
//   String address;
//   String pincode;
//   String landmark;
//   num yearOfExperience;
//   num totReview;
//   num avgStar;

//   Doctor({
//     required this.id,
//     required this.logo,
//     required this.name,
//     required this.countryCode,
//     required this.phone,
//     required this.address,
//     required this.pincode,
//     required this.landmark,
//     required this.yearOfExperience,
//     required this.totReview,
//     required this.avgStar,
//   });

//   factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
//     id: json["id"],
//     logo: json["logo"],
//     name: json["name"],
//     countryCode: json["country_code"],
//     phone: json["phone"],
//     address: json["address"],
//     pincode: json["pincode"],
//     landmark: json["landmark"],
//     yearOfExperience: json["year_of_experience"],
//     totReview: json["tot_review"],
//     avgStar: json["avg_star"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "logo": logo,
//     "name": name,
//     "country_code": countryCode,
//     "phone": phone,
//     "address": address,
//     "pincode": pincode,
//     "landmark": landmark,
//     "year_of_experience": yearOfExperience,
//     "tot_review": totReview,
//     "avg_star": avgStar,
//   };
// }

// class FamilyMember {
//   int id;
//   String customerId;
//   String profileImage;
//   String name;
//   String relationship;
//   String bloodType;
//   String gender;
//   num patientAge;
//   String nationalId;
//   String height;
//   String weight;
//   String allergies;
//   String medicalHistory;

//   FamilyMember({
//     required this.id,
//     required this.customerId,
//     required this.profileImage,
//     required this.name,
//     required this.relationship,
//     required this.bloodType,
//     required this.gender,
//     required this.patientAge,
//     required this.nationalId,
//     required this.height,
//     required this.weight,
//     required this.allergies,
//     required this.medicalHistory,
//   });

//   factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
//     id: json["id"],
//     customerId: json["customer_id"],
//     profileImage: json["profile_image"],
//     name: json["name"],
//     relationship: json["relationship"],
//     bloodType: json["blood_type"],
//     gender: json["gender"],
//     patientAge: json["patient_age"],
//     nationalId: json["national_id"],
//     height: json["height"],
//     weight: json["weight"],
//     allergies: json["allergies"],
//     medicalHistory: json["medical_history"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "customer_id": customerId,
//     "profile_image": profileImage,
//     "name": name,
//     "relationship": relationship,
//     "blood_type": bloodType,
//     "gender": gender,
//     "patient_age": patientAge,
//     "national_id": nationalId,
//     "height": height,
//     "weight": weight,
//     "allergies": allergies,
//     "medical_history": medicalHistory,
//   };
// }

// class Hospital {
//   int id;
//   String image;
//   String name;
//   String email;
//   String countryCode;
//   String phone;
//   String address;
//   String latitude;
//   String longitude;

//   Hospital({
//     required this.id,
//     required this.image,
//     required this.name,
//     required this.email,
//     required this.countryCode,
//     required this.phone,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//   });

//   factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
//     id: json["id"],
//     image: json["image"],
//     name: json["name"],
//     email: json["email"],
//     countryCode: json["country_code"],
//     phone: json["phone"],
//     address: json["address"],
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "image": image,
//     "name": name,
//     "email": email,
//     "country_code": countryCode,
//     "phone": phone,
//     "address": address,
//     "latitude": latitude,
//     "longitude": longitude,
//   };
// }

// class Sebservice {
//   int id;
//   String departImage;
//   String departmentName;
//   String subTitle;
//   String image;
//   num clientVisitPrice;
//   num videoConsultPrice;
//   String showType;

//   Sebservice({
//     required this.id,
//     required this.departImage,
//     required this.departmentName,
//     required this.subTitle,
//     required this.image,
//     required this.clientVisitPrice,
//     required this.videoConsultPrice,
//     required this.showType,
//   });

//   factory Sebservice.fromJson(Map<String, dynamic> json) => Sebservice(
//     id: json["id"],
//     departImage: json["depart_image"],
//     departmentName: json["department_name"],
//     subTitle: json["sub_title"],
//     image: json["image"],
//     clientVisitPrice: json["client_visit_price"],
//     videoConsultPrice: json["video_consult_price"],
//     showType: json["show_type"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "depart_image": departImage,
//     "department_name": departmentName,
//     "sub_title": subTitle,
//     "image": image,
//     "client_visit_price": clientVisitPrice,
//     "video_consult_price": videoConsultPrice,
//     "show_type": showType,
//   };
// }
