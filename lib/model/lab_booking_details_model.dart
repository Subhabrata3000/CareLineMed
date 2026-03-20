// To parse this JSON data, do
//
//     final labBookingDetailsModel = labBookingDetailsModelFromJson(jsonString);

import 'dart:convert';

LabBookingDetailsModel labBookingDetailsModelFromJson(String str) =>
    LabBookingDetailsModel.fromJson(json.decode(str));

String labBookingDetailsModelToJson(LabBookingDetailsModel data) =>
    json.encode(data.toJson());

class LabBookingDetailsModel {
  int? responseCode;
  bool? result;
  String? message;
  Appoint? appoint;
  Lab? lab;
  Category? category;

  LabBookingDetailsModel({
    this.responseCode,
    this.result,
    this.message,
    this.appoint,
    this.lab,
    this.category,
  });

  factory LabBookingDetailsModel.fromJson(Map<String, dynamic> json) =>
      LabBookingDetailsModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        appoint: json["appoint"] == null ? null : Appoint.fromJson(json["appoint"]),
        lab: json["lab"] == null ? null : Lab.fromJson(json["lab"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "appoint": appoint?.toJson(),
        "lab": lab?.toJson(),
        "category": category?.toJson(),
      };
}

class Appoint {
  int? id;
  String? customerId;
  String? labId;
  String? categoryId;
  String? status;
  String? date;
  String? bookDate;
  String? bookTime;
  String? message;
  String? address;
  double? totPackagePrice;
  double? totPrice;
  double? paidAmount;
  String? couponId;
  double? couponAmount;
  double? homeExtraPrice;
  String? homeColStatus;
  int? siteCommission;
  String? paymentId;
  double? walletAmount;
  String? otp;
  double? onlineAmount;
  double? cashAmount;
  String? paymentName;
  String? paymentImage;
  String? reviewCheck;
  String? homeCUser;
  String? homeCEmail;
  String? homeCCcode;
  String? homeCPhone;
  String? statusType;
  String? cancelTitle;
  String? cancelReason;
  String? transactionId;
  String? qrcode;
  List<StatusList>? statusList;
  List<Package>? packageId;

  Appoint({
    this.id,
    this.customerId,
    this.labId,
    this.categoryId,
    this.status,
    this.date,
    this.bookDate,
    this.bookTime,
    this.message,
    this.address,
    this.totPackagePrice,
    this.totPrice,
    this.paidAmount,
    this.couponId,
    this.couponAmount,
    this.homeExtraPrice,
    this.homeColStatus,
    this.siteCommission,
    this.paymentId,
    this.walletAmount,
    this.otp,
    this.onlineAmount,
    this.cashAmount,
    this.paymentName,
    this.paymentImage,
    this.reviewCheck,
    this.homeCUser,
    this.homeCEmail,
    this.homeCCcode,
    this.homeCPhone,
    this.statusType,
    this.cancelTitle,
    this.cancelReason,
    this.transactionId,
    this.qrcode,
    this.statusList,
    this.packageId,
  });

  factory Appoint.fromJson(Map<String, dynamic> json) => Appoint(
        id: json["id"],
        customerId: json["customer_id"],
        labId: json["lab_id"],
        categoryId: json["category_id"],
        status: json["status"],
        date: json["date"],
        bookDate: json["book_date"],
        bookTime: json["book_time"],
        message: json["message"],
        address: json["address"],
        totPackagePrice: (json["tot_package_price"] as num?)?.toDouble(),
        totPrice: (json["tot_price"] as num?)?.toDouble(),
        paidAmount: (json["paid_amount"] as num?)?.toDouble(),
        couponId: json["coupon_id"],
        couponAmount: (json["coupon_amount"] as num?)?.toDouble(),
        homeExtraPrice: (json["home_extra_price"] as num?)?.toDouble(),
        homeColStatus: json["home_col_status"],
        siteCommission: json["site_commission"],
        paymentId: json["payment_id"],
        walletAmount: (json["wallet_amount"] as num?)?.toDouble(),
        otp: json["otp"],
        onlineAmount: (json["online_amount"] as num?)?.toDouble(),
        cashAmount: (json["cash_amount"] as num?)?.toDouble(),
        paymentName: json["payment_name"],
        paymentImage: json["payment_image"],
        reviewCheck: json["review_check"],
        homeCUser: json["home_c_user"],
        homeCEmail: json["home_c_email"],
        homeCCcode: json["home_c_ccode"],
        homeCPhone: json["home_c_phone"],
        statusType: json["status_type"],
        cancelTitle: json["cancel_title"],
        cancelReason: json["cancel_reason"],
        transactionId: json["transactionId"],
        qrcode: json["qrcode"],
        statusList: json["status_list"] == null
            ? []
            : List<StatusList>.from(json["status_list"].map((x) => StatusList.fromJson(x))),
        packageId: json["package_id"] == null
            ? []
            : List<Package>.from(json["package_id"].map((x) => Package.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "lab_id": labId,
        "category_id": categoryId,
        "status": status,
        "date": date,
        "book_date": bookDate,
        "book_time": bookTime,
        "message": message,
        "address": address,
        "tot_package_price": totPackagePrice,
        "tot_price": totPrice,
        "paid_amount": paidAmount,
        "coupon_id": couponId,
        "coupon_amount": couponAmount,
        "home_extra_price": homeExtraPrice,
        "home_col_status": homeColStatus,
        "site_commission": siteCommission,
        "payment_id": paymentId,
        "wallet_amount": walletAmount,
        "otp": otp,
        "online_amount": onlineAmount,
        "cash_amount": cashAmount,
        "payment_name": paymentName,
        "payment_image": paymentImage,
        "review_check": reviewCheck,
        "home_c_user": homeCUser,
        "home_c_email": homeCEmail,
        "home_c_ccode": homeCCcode,
        "home_c_phone": homeCPhone,
        "status_type": statusType,
        "cancel_title": cancelTitle,
        "cancel_reason": cancelReason,
        "transactionId": transactionId,
        "qrcode": qrcode,
        "status_list": statusList?.map((x) => x.toJson()).toList(),
        "package_id": packageId?.map((x) => x.toJson()).toList(),
      };
}

class StatusList {
  int? s;
  String? t;

  StatusList({
    this.s,
    this.t,
  });

  factory StatusList.fromJson(Map<String, dynamic> json) => StatusList(
        s: json["s"],
        t: json["t"],
      );

  Map<String, dynamic> toJson() => {
        "s": s,
        "t": t,
      };
}

class Package {
  List<PackageFeature>? f;
  int? pid;
  String? logo;
  String? title;
  String? subtitle;
  String? description;
  List<String>? sampleType;
  List<String>? packageName;
  String? packageType;
  List<int>? packagePrice;
  String? fastingRequire;
  int? homeExtraPrice;
  String? testReportTime;
  int? totPackageName;
  int? totPackagePrice;

  Package({
    this.f,
    this.pid,
    this.logo,
    this.title,
    this.subtitle,
    this.description,
    this.sampleType,
    this.packageName,
    this.packageType,
    this.packagePrice,
    this.fastingRequire,
    this.homeExtraPrice,
    this.testReportTime,
    this.totPackageName,
    this.totPackagePrice,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        f: json["f"] == null
            ? []
            : List<PackageFeature>.from(json["f"].map((x) => PackageFeature.fromJson(x))),
        pid: json["pid"],
        logo: json["logo"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        sampleType: List<String>.from(json["sample_type"]),
        packageName: List<String>.from(json["package_name"]),
        packageType: json["package_type"],
        packagePrice: List<int>.from(json["package_price"]),
        fastingRequire: json["fasting_require"],
        homeExtraPrice: json["home_extra_price"],
        testReportTime: json["test_report_time"],
        totPackageName: json["tot_package_name"],
        totPackagePrice: json["tot_package_price"],
      );

  Map<String, dynamic> toJson() => {
        "f": f?.map((x) => x.toJson()).toList(),
        "pid": pid,
        "logo": logo,
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "sample_type": sampleType,
        "package_name": packageName,
        "package_type": packageType,
        "package_price": packagePrice,
        "fasting_require": fastingRequire,
        "home_extra_price": homeExtraPrice,
        "test_report_time": testReportTime,
        "tot_package_name": totPackageName,
        "tot_package_price": totPackagePrice,
      };
}

class PackageFeature {
  String? c;
  String? d;
  List<dynamic>? r;
  FMember? fmember;

  PackageFeature({
    this.c,
    this.d,
    this.r,
    this.fmember,
  });

  factory PackageFeature.fromJson(Map<String, dynamic> json) => PackageFeature(
        c: json["c"],
        d: json["d"],
        r: List<dynamic>.from(json["r"] ?? []),
        fmember: json["fmember"] == null ? null : FMember.fromJson(json["fmember"]),
      );

  Map<String, dynamic> toJson() => {
        "c": c,
        "d": d,
        "r": r,
        "fmember": fmember?.toJson(),
      };
}

class FMember {
  int? id;
  String? name;
  String? profileImage;

  FMember({
    this.id,
    this.name,
    this.profileImage,
  });

  factory FMember.fromJson(Map<String, dynamic> json) => FMember(
        id: json["id"],
        name: json["name"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_image": profileImage,
      };
}

class Lab {
  int? id;
  String? logo;
  String? name;
  String? licenseNumber;
  String? address;
  String? latitude;
  String? longitude;
  int? totReview;
  int? avgStar;

  Lab({
    this.id,
    this.logo,
    this.name,
    this.licenseNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.totReview,
    this.avgStar,
  });

  factory Lab.fromJson(Map<String, dynamic> json) => Lab(
        id: json["id"],
        logo: json["logo"],
        name: json["name"],
        licenseNumber: json["license_number"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        totReview: json["tot_review"],
        avgStar: json["avg_star"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "name": name,
        "license_number": licenseNumber,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "tot_review": totReview,
        "avg_star": avgStar,
      };
}

class Category {
  int? id;
  String? image;
  String? name;

  Category({
    this.id,
    this.image,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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


// import 'dart:convert';

// LabBookingDetailsModel labBookingDetailsModelFromJson(String str) => LabBookingDetailsModel.fromJson(json.decode(str));

// String labBookingDetailsModelToJson(LabBookingDetailsModel data) => json.encode(data.toJson());

// class LabBookingDetailsModel {
//   int? responseCode;
//   bool? result;
//   String? message;
//   Appointment? appoint;
//   Lab? lab;
//   Category? category;

//   LabBookingDetailsModel({
//     this.responseCode,
//     this.result,
//     this.message,
//     this.appoint,
//     this.lab,
//     this.category,
//   });

//   factory LabBookingDetailsModel.fromJson(Map<String, dynamic> json) =>
//       LabBookingDetailsModel(
//         responseCode: json["ResponseCode"],
//         result: json["Result"],
//         message: json["message"],
//         appoint:
//             json["appoint"] != null ? Appointment.fromJson(json["appoint"]) : null,
//         lab: json["lab"] != null ? Lab.fromJson(json["lab"]) : null,
//         category:
//             json["category"] != null ? Category.fromJson(json["category"]) : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "ResponseCode": responseCode,
//         "Result": result,
//         "message": message,
//         "appoint": appoint?.toJson(),
//         "lab": lab?.toJson(),
//         "category": category?.toJson(),
//       };
// }

// class Appointment {
//   int? id;
//   String? customerId;
//   String? labId;
//   String? categoryId;
//   String? status;
//   String? date;
//   String? bookDate;
//   String? bookTime;
//   String? message;
//   String? address;
//   num? totPackagePrice;
//   num? totPrice;
//   num? paidAmount;
//   String? couponId;
//   num? couponAmount;
//   num? homeExtraPrice;
//   String? homeColStatus;
//   num? siteCommission;
//   String? paymentId;
//   num? walletAmount;
//   String? otp;
//   num? onlineAmount;
//   num? cashAmount;
//   String? paymentName;
//   String? paymentImage;
//   String? reviewCheck;
//   String? qrcode;
//   String? statusType;
//   String? cancelTitle;
//   String? cancelReason;
//   List<StatusList>? statusList;
//   List<PackageId>? packageId;

//   Appointment({
//     this.id,
//     this.customerId,
//     this.labId,
//     this.categoryId,
//     this.status,
//     this.date,
//     this.bookDate,
//     this.bookTime,
//     this.message,
//     this.address,
//     this.totPackagePrice,
//     this.totPrice,
//     this.paidAmount,
//     this.couponId,
//     this.couponAmount,
//     this.homeExtraPrice,
//     this.homeColStatus,
//     this.siteCommission,
//     this.paymentId,
//     this.walletAmount,
//     this.otp,
//     this.onlineAmount,
//     this.cashAmount,
//     this.paymentName,
//     this.paymentImage,
//     this.reviewCheck,
//     this.qrcode,
//     this.statusType,
//     this.cancelTitle,
//     this.cancelReason,
//     this.statusList,
//     this.packageId,
//   });

//   factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
//         id: json["id"],
//         customerId: json["customer_id"],
//         labId: json["lab_id"],
//         categoryId: json["category_id"],
//         status: json["status"],
//         date: json["date"],
//         bookDate: json["book_date"],
//         bookTime: json["book_time"],
//         message: json["message"],
//         address: json["address"],
//         totPackagePrice: (json["tot_package_price"] ?? 0).toDouble(),
//         totPrice: (json["tot_price"] ?? 0).toDouble(),
//         paidAmount: (json["paid_amount"] ?? 0).toDouble(),
//         couponId: json["coupon_id"],
//         couponAmount: (json["coupon_amount"] ?? 0).toDouble(),
//         homeExtraPrice: (json["home_extra_price"] ?? 0).toDouble(),
//         homeColStatus: json["home_col_status"],
//         siteCommission: (json["site_commission"] ?? 0).toDouble(),
//         paymentId: json["payment_id"],
//         walletAmount: (json["wallet_amount"] ?? 0).toDouble(),
//         otp: json["otp"],
//         onlineAmount: (json["online_amount"] ?? 0).toDouble(),
//         cashAmount: (json["cash_amount"] ?? 0).toDouble(),
//         paymentName: json["payment_name"],
//         paymentImage: json["payment_image"],
//         reviewCheck: json["review_check"],
//         qrcode: json["qrcode"],
//         statusType: json["status_type"],
//         cancelTitle: json["cancel_title"],
//         cancelReason: json["cancel_reason"],
//         statusList: json["status_list"] != null
//             ? List<StatusList>.from(
//                 json["status_list"].map((x) => StatusList.fromJson(x)))
//             : [],
//         packageId: json["package_id"] != null
//             ? List<PackageId>.from(
//                 json["package_id"].map((x) => PackageId.fromJson(x)))
//             : [],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "customer_id": customerId,
//         "lab_id": labId,
//         "category_id": categoryId,
//         "status": status,
//         "date": date,
//         "book_date": bookDate,
//         "book_time": bookTime,
//         "message": message,
//         "address": address,
//         "tot_package_price": totPackagePrice,
//         "tot_price": totPrice,
//         "paid_amount": paidAmount,
//         "coupon_id": couponId,
//         "coupon_amount": couponAmount,
//         "home_extra_price": homeExtraPrice,
//         "home_col_status": homeColStatus,
//         "site_commission": siteCommission,
//         "payment_id": paymentId,
//         "wallet_amount": walletAmount,
//         "otp": otp,
//         "online_amount": onlineAmount,
//         "cash_amount": cashAmount,
//         "payment_name": paymentName,
//         "payment_image": paymentImage,
//         "review_check": reviewCheck,
//         "qrcode": qrcode,
//         "status_type": statusType,
//         "cancel_title": cancelTitle,
//         "cancel_reason": cancelReason,
//         "status_list": statusList?.map((x) => x.toJson()).toList(),
//         "package_id": packageId?.map((x) => x.toJson()).toList(),
//       };
// }

// class StatusList {
//   int? s;
//   String? t;

//   StatusList({this.s, this.t});

//   factory StatusList.fromJson(Map<String, dynamic> json) => StatusList(
//         s: json["s"],
//         t: json["t"],
//       );

//   Map<String, dynamic> toJson() => {
//         "s": s,
//         "t": t,
//       };
// }

// class PackageId {
//   List<FamilyMemberPackage>? f;
//   int? pid;
//   String? logo;
//   String? title;
//   String? subtitle;
//   String? description;
//   List<String>? sampleType;
//   List<String>? packageName;
//   String? packageType;
//   List<double>? packagePrice;
//   String? fastingRequire;
//   num? homeExtraPrice;
//   String? testReportTime;
//   int? totPackageName;
//   num? totPackagePrice;

//   PackageId({
//     this.f,
//     this.pid,
//     this.logo,
//     this.title,
//     this.subtitle,
//     this.description,
//     this.sampleType,
//     this.packageName,
//     this.packageType,
//     this.packagePrice,
//     this.fastingRequire,
//     this.homeExtraPrice,
//     this.testReportTime,
//     this.totPackageName,
//     this.totPackagePrice,
//   });

//   factory PackageId.fromJson(Map<String, dynamic> json) => PackageId(
//         f: json["f"] != null
//             ? List<FamilyMemberPackage>.from(
//                 json["f"].map((x) => FamilyMemberPackage.fromJson(x)))
//             : [],
//         pid: json["pid"],
//         logo: json["logo"],
//         title: json["title"],
//         subtitle: json["subtitle"],
//         description: json["description"],
//         sampleType: List<String>.from(json["sample_type"] ?? []),
//         packageName: List<String>.from(json["package_name"] ?? []),
//         packageType: json["package_type"],
//         packagePrice: List<double>.from(
//             (json["package_price"] ?? []).map((x) => x.toDouble())),
//         fastingRequire: json["fasting_require"],
//         homeExtraPrice: (json["home_extra_price"] ?? 0).toDouble(),
//         testReportTime: json["test_report_time"],
//         totPackageName: json["tot_package_name"],
//         totPackagePrice: (json["tot_package_price"] ?? 0).toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "f": f?.map((x) => x.toJson()).toList(),
//         "pid": pid,
//         "logo": logo,
//         "title": title,
//         "subtitle": subtitle,
//         "description": description,
//         "sample_type": sampleType,
//         "package_name": packageName,
//         "package_type": packageType,
//         "package_price": packagePrice,
//         "fasting_require": fastingRequire,
//         "home_extra_price": homeExtraPrice,
//         "test_report_time": testReportTime,
//         "tot_package_name": totPackageName,
//         "tot_package_price": totPackagePrice,
//       };
// }

// class FamilyMemberPackage {
//   String? c;
//   String? d;
//   List<dynamic>? r;
//   FMember? fmember;

//   FamilyMemberPackage({
//     this.c,
//     this.d,
//     this.r,
//     this.fmember,
//   });

//   factory FamilyMemberPackage.fromJson(Map<String, dynamic> json) =>
//       FamilyMemberPackage(
//         c: json["c"],
//         d: json["d"],
//         r: json["r"],
//         fmember:
//             json["fmember"] != null ? FMember.fromJson(json["fmember"]) : null,
//       );

//   Map<String, dynamic> toJson() => {
//         "c": c,
//         "d": d,
//         "r": r,
//         "fmember": fmember?.toJson(),
//       };
// }

// class FMember {
//   int? id;
//   String? name;
//   String? profileImage;

//   FMember({
//     this.id,
//     this.name,
//     this.profileImage,
//   });

//   factory FMember.fromJson(Map<String, dynamic> json) => FMember(
//         id: json["id"],
//         name: json["name"],
//         profileImage: json["profile_image"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "profile_image": profileImage,
//       };
// }

// class Lab {
//   int? id;
//   String? logo;
//   String? name;
//   String? licenseNumber;
//   String? address;
//   String? latitude;
//   String? longitude;
//   int? totReview;
//   num? avgStar;

//   Lab({
//     this.id,
//     this.logo,
//     this.name,
//     this.licenseNumber,
//     this.address,
//     this.latitude,
//     this.longitude,
//     this.totReview,
//     this.avgStar,
//   });

//   factory Lab.fromJson(Map<String, dynamic> json) => Lab(
//         id: json["id"],
//         logo: json["logo"],
//         name: json["name"],
//         licenseNumber: json["license_number"],
//         address: json["address"],
//         latitude: json["latitude"],
//         longitude: json["longitude"],
//         totReview: json["tot_review"],
//         avgStar: (json["avg_star"] ?? 0).toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "logo": logo,
//         "name": name,
//         "license_number": licenseNumber,
//         "address": address,
//         "latitude": latitude,
//         "longitude": longitude,
//         "tot_review": totReview,
//         "avg_star": avgStar,
//       };
// }

// class Category {
//   int? id;
//   String? image;
//   String? name;

//   Category({
//     this.id,
//     this.image,
//     this.name,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//         id: json["id"],
//         image: json["image"],
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "image": image,
//         "name": name,
//       };
// }
