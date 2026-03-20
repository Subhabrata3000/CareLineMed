// To parse this JSON data, do
//
//     final doctorDetailModel = doctorDetailModelFromJson(jsonString);

import 'dart:convert';

DoctorDetailModel doctorDetailModelFromJson(String str) => DoctorDetailModel.fromJson(json.decode(str));

String doctorDetailModelToJson(DoctorDetailModel data) => json.encode(data.toJson());

class DoctorDetailModel {
    int? responseCode;
    bool? result;
    String? message;
    Doctor? doctor;
    List<DepSubSerList>? depSubSerList;
    List<AboutDatum>? aboutData;
    List<ReviewDatum>? reviewData;
    List<AwardDatum>? awardData;
    List<GalleryList>? galleryList;
    List<FaqDatum>? faqData;
    List<HospitalList>? hospitalList;
    List<Alldate>? alldate;
    // Ndatelist? ndatelist;

    DoctorDetailModel({
        this.responseCode,
        this.result,
        this.message,
        this.doctor,
        this.depSubSerList,
        this.aboutData,
        this.reviewData,
        this.awardData,
        this.galleryList,
        this.faqData,
        this.hospitalList,
        this.alldate,
        // this.ndatelist,
    });

    factory DoctorDetailModel.fromJson(Map<String, dynamic> json) => DoctorDetailModel(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        message: json["message"],
        doctor: json["doctor"] == null ? null : Doctor.fromJson(json["doctor"]),
        depSubSerList: json["dep_sub_ser_list"] == null ? [] : List<DepSubSerList>.from(json["dep_sub_ser_list"]!.map((x) => DepSubSerList.fromJson(x))),
        aboutData: json["about_data"] == null ? [] : List<AboutDatum>.from(json["about_data"]!.map((x) => AboutDatum.fromJson(x))),
        reviewData: json["review_data"] == null ? [] : List<ReviewDatum>.from(json["review_data"]!.map((x) => ReviewDatum.fromJson(x))),
        awardData: json["award_data"] == null ? [] : List<AwardDatum>.from(json["award_data"]!.map((x) => AwardDatum.fromJson(x))),
        galleryList: json["gallery_list"] == null ? [] : List<GalleryList>.from(json["gallery_list"]!.map((x) => GalleryList.fromJson(x))),
        faqData: json["faq_data"] == null ? [] : List<FaqDatum>.from(json["faq_data"]!.map((x) => FaqDatum.fromJson(x))),
        hospitalList: json["hospital_list"] == null ? [] : List<HospitalList>.from(json["hospital_list"]!.map((x) => HospitalList.fromJson(x))),
        alldate: json["alldate"] == null ? [] : List<Alldate>.from(json["alldate"]!.map((x) => Alldate.fromJson(x))),
        // ndatelist: json["ndatelist"] == null ? null : Ndatelist.fromJson(json["ndatelist"]),
    );

    Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "message": message,
        "doctor": doctor?.toJson(),
        "dep_sub_ser_list": depSubSerList == null ? [] : List<dynamic>.from(depSubSerList!.map((x) => x.toJson())),
        "about_data": aboutData == null ? [] : List<dynamic>.from(aboutData!.map((x) => x.toJson())),
        "review_data": reviewData == null ? [] : List<dynamic>.from(reviewData!.map((x) => x.toJson())),
        "award_data": awardData == null ? [] : List<dynamic>.from(awardData!.map((x) => x.toJson())),
        "gallery_list": galleryList == null ? [] : List<dynamic>.from(galleryList!.map((x) => x.toJson())),
        "faq_data": faqData == null ? [] : List<dynamic>.from(faqData!.map((x) => x.toJson())),
        "hospital_list": hospitalList == null ? [] : List<dynamic>.from(hospitalList!.map((x) => x.toJson())),
        "alldate": alldate == null ? [] : List<dynamic>.from(alldate!.map((x) => x.toJson())),
        // "ndatelist": ndatelist?.toJson(),
    };
}

class AboutDatum {
    String? head;
    String? description;
    String? title;
    List<About>? about;

    AboutDatum({
        this.head,
        this.description,
        this.title,
        this.about,
    });

    factory AboutDatum.fromJson(Map<String, dynamic> json) => AboutDatum(
        head: json["head"],
        description: json["description"],
        title: json["title"],
        about: json["about"] == null ? [] : List<About>.from(json["about"]!.map((x) => About.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "head": head,
        "description": description,
        "title": title,
        "about": about == null ? [] : List<dynamic>.from(about!.map((x) => x.toJson())),
    };
}

class About {
    String? id;
    String? icon;
    String? subtitle;

    About({
        this.id,
        this.icon,
        this.subtitle,
    });

    factory About.fromJson(Map<String, dynamic> json) => About(
        id: json["id"],
        icon: json["icon"],
        subtitle: json["subtitle"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "subtitle": subtitle,
    };
}

class Alldate {
    String? date;
    String? weekDay;
    num? avaiSlot;

    Alldate({
        this.date,
        this.weekDay,
        this.avaiSlot,
    });

    factory Alldate.fromJson(Map<String, dynamic> json) => Alldate(
        date: json["date"],
        weekDay: json["week_day"],
        avaiSlot: json["avai_slot"],
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "week_day": weekDay,
        "avai_slot": avaiSlot,
    };
}

class AwardDatum {
    int? id;
    String? doctorId;
    String? image;
    String? title;
    String? status;

    AwardDatum({
        this.id,
        this.doctorId,
        this.image,
        this.title,
        this.status,
    });

    factory AwardDatum.fromJson(Map<String, dynamic> json) => AwardDatum(
        id: json["id"],
        doctorId: json["doctor_id"],
        image: json["image"],
        title: json["title"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "image": image,
        "title": title,
        "status": status,
    };
}

class DepSubSerList {
    int? id;
    String? hospitalId;
    String? departmentId;
    String? subTitle;
    String? image;
    num? clientVisitPrice;
    num? videoConsultPrice;
    String? showType;

    DepSubSerList({
        this.id,
        this.hospitalId,
        this.departmentId,
        this.subTitle,
        this.image,
        this.clientVisitPrice,
        this.videoConsultPrice,
        this.showType,
    });

    factory DepSubSerList.fromJson(Map<String, dynamic> json) => DepSubSerList(
        id: json["id"],
        hospitalId: json["hospital_id"],
        departmentId: json["department_id"],
        subTitle: json["sub_title"],
        image: json["image"],
        clientVisitPrice: json["client_visit_price"],
        videoConsultPrice: json["video_consult_price"],
        showType: json["show_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "hospital_id": hospitalId,
        "department_id": departmentId,
        "sub_title": subTitle,
        "image": image,
        "client_visit_price": clientVisitPrice,
        "video_consult_price": videoConsultPrice,
        "show_type": showType,
    };
}


class Doctor {
    int? id;
    String? logo;
    String? coverLogo;
    String? name;
    String? email;
    String? countryCode;
    String? phone;
    String? verificationStatus;
    String? title;
    String? subtitle;
    String? description;
    String? cancelPolicy;
    String? address;
    String? pincode;
    String? landmark;
    num? commission;
    num? yearOfExperience;
    num? perPatientTime;
    num? totFavorite;
    num? chatCheck;
    String? ad;
    String? at;
    num? timecount;
    num? totReview;
    num? avgStar;
    num? minInpPrice;
    num? maxInpPrice;
    num? minVidPrice;
    num? maxVidPrice;

    Doctor({
        this.id,
        this.logo,
        this.coverLogo,
        this.name,
        this.email,
        this.countryCode,
        this.phone,
        this.verificationStatus,
        this.title,
        this.subtitle,
        this.description,
        this.cancelPolicy,
        this.address,
        this.pincode,
        this.landmark,
        this.commission,
        this.yearOfExperience,
        this.perPatientTime,
        this.totFavorite,
        this.chatCheck,
        this.ad,
        this.at,
        this.timecount,
        this.totReview,
        this.avgStar,
        this.minInpPrice,
        this.maxInpPrice,
        this.minVidPrice,
        this.maxVidPrice,
    });

    factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        logo: json["logo"],
        coverLogo: json["cover_logo"],
        name: json["name"],
        email: json["email"],
        countryCode: json["country_code"],
        phone: json["phone"],
        verificationStatus: json["verification_status"],
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        cancelPolicy: json["cancel_policy"],
        address: json["address"],
        pincode: json["pincode"],
        landmark: json["landmark"],
        commission: json["commission"],
        yearOfExperience: json["year_of_experience"],
        perPatientTime: json["per_patient_time"],
        totFavorite: json["tot_favorite"],
        chatCheck: json["chat_check"],
        ad: json["ad"],
        at: json["at"],
        timecount: json["timecount"],
        totReview: json["tot_review"],
        avgStar: json["avg_star"],
        minInpPrice: json["min_inp_price"],
        maxInpPrice: json["max_inp_price"],
        minVidPrice: json["min_vid_price"],
        maxVidPrice: json["max_vid_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "cover_logo": coverLogo,
        "name": name,
        "email": email,
        "country_code": countryCode,
        "phone": phone,
        "verification_status": verificationStatus,
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "cancel_policy": cancelPolicy,
        "address": address,
        "pincode": pincode,
        "landmark": landmark,
        "commission": commission,
        "year_of_experience": yearOfExperience,
        "per_patient_time": perPatientTime,
        "tot_favorite": totFavorite,
        "chat_check": chatCheck,
        "ad": ad,
        "at": at,
        "timecount": timecount,
        "tot_review": totReview,
        "avg_star": avgStar,
        "min_inp_price": minInpPrice,
        "max_inp_price": maxInpPrice,
        "min_vid_price": minVidPrice,
        "max_vid_price": maxVidPrice,
    };
}

// class Doctor {
//     int? id;
//     String? logo;
//     String? coverLogo;
//     String? name;
//     String? email;
//     String? countryCode;
//     String? phone;
//     String? verificationStatus;
//     String? title;
//     String? subtitle;
//     String? description;
//     String? cancelPolicy;
//     String? address;
//     String? pincode;
//     String? landmark;
//     num? commission;
//     num? yearOfExperience;
//     num? perPatientTime;
//     num? totFavorite;
//     num? totReview;
//     double? avgStar;
//     num? minInpPrice;
//     num? maxInpPrice;
//     num? minVidPrice;
//     num? maxVidPrice;

//     Doctor({
//         this.id,
//         this.logo,
//         this.coverLogo,
//         this.name,
//         this.email,
//         this.countryCode,
//         this.phone,
//         this.verificationStatus,
//         this.title,
//         this.subtitle,
//         this.description,
//         this.cancelPolicy,
//         this.address,
//         this.pincode,
//         this.landmark,
//         this.commission,
//         this.yearOfExperience,
//         this.perPatientTime,
//         this.totFavorite,
//         this.totReview,
//         this.avgStar,
//         this.minInpPrice,
//         this.maxInpPrice,
//         this.minVidPrice,
//         this.maxVidPrice,
//     });

//     factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
//         id: json["id"],
//         logo: json["logo"],
//         coverLogo: json["cover_logo"],
//         name: json["name"],
//         email: json["email"],
//         countryCode: json["country_code"],
//         phone: json["phone"],
//         verificationStatus: json["verification_status"],
//         title: json["title"],
//         subtitle: json["subtitle"],
//         description: json["description"],
//         cancelPolicy: json["cancel_policy"],
//         address: json["address"],
//         pincode: json["pincode"],
//         landmark: json["landmark"],
//         commission: json["commission"],
//         yearOfExperience: json["year_of_experience"],
//         perPatientTime: json["per_patient_time"],
//         totFavorite: json["tot_favorite"],
//         totReview: json["tot_review"],
//         avgStar: json["avg_star"]?.toDouble(),
//         minInpPrice: json["min_inp_price"],
//         maxInpPrice: json["max_inp_price"],
//         minVidPrice: json["min_vid_price"],
//         maxVidPrice: json["max_vid_price"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "logo": logo,
//         "cover_logo": coverLogo,
//         "name": name,
//         "email": email,
//         "country_code": countryCode,
//         "phone": phone,
//         "verification_status": verificationStatus,
//         "title": title,
//         "subtitle": subtitle,
//         "description": description,
//         "cancel_policy": cancelPolicy,
//         "address": address,
//         "pincode": pincode,
//         "landmark": landmark,
//         "commission": commission,
//         "year_of_experience": yearOfExperience,
//         "per_patient_time": perPatientTime,
//         "tot_favorite": totFavorite,
//         "tot_review": totReview,
//         "avg_star": avgStar,
//         "min_inp_price": minInpPrice,
//         "max_inp_price": maxInpPrice,
//         "min_vid_price": minVidPrice,
//         "max_vid_price": maxVidPrice,
//     };
// }

class FaqDatum {
    String? title;
    String? description;

    FaqDatum({
        this.title,
        this.description,
    });

    factory FaqDatum.fromJson(Map<String, dynamic> json) => FaqDatum(
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
    };
}

class GalleryList {
    String? image;

    GalleryList({
        this.image,
    });

    factory GalleryList.fromJson(Map<String, dynamic> json) => GalleryList(
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
    };
}

class HospitalList {
    int? id;
    String? image;
    String? name;
    String? email;
    String? countryCode;
    String? phone;
    String? address;

    HospitalList({
        this.id,
        this.image,
        this.name,
        this.email,
        this.countryCode,
        this.phone,
        this.address,
    });

    factory HospitalList.fromJson(Map<String, dynamic> json) => HospitalList(
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

class Ndatelist {
    DateTime? date;
    String? weekDay;
    num? avaiSlot;
    List<dynamic>? morning;
    List<Afternoon>? afternoon;
    List<Afternoon>? evening;

    Ndatelist({
        this.date,
        this.weekDay,
        this.avaiSlot,
        this.morning,
        this.afternoon,
        this.evening,
    });

    factory Ndatelist.fromJson(Map<String, dynamic> json) => Ndatelist(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        weekDay: json["week_day"],
        avaiSlot: json["avai_slot"],
        morning: json["Morning"] == null ? [] : List<dynamic>.from(json["Morning"]!.map((x) => x)),
        afternoon: json["Afternoon"] == null ? [] : List<Afternoon>.from(json["Afternoon"]!.map((x) => Afternoon.fromJson(x))),
        evening: json["Evening"] == null ? [] : List<Afternoon>.from(json["Evening"]!.map((x) => Afternoon.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "week_day": weekDay,
        "avai_slot": avaiSlot,
        "Morning": morning == null ? [] : List<dynamic>.from(morning!.map((x) => x)),
        "Afternoon": afternoon == null ? [] : List<dynamic>.from(afternoon!.map((x) => x.toJson())),
        "Evening": evening == null ? [] : List<dynamic>.from(evening!.map((x) => x.toJson())),
    };
}

class Afternoon {
    String? t;
    num? o;
    String? hid;

    Afternoon({
        this.t,
        this.o,
        this.hid,
    });

    factory Afternoon.fromJson(Map<String, dynamic> json) => Afternoon(
        t: json["t"],
        o: json["o"],
        hid: json["hid"],
    );

    Map<String, dynamic> toJson() => {
        "t": t,
        "o": o,
        "hid": hid,
    };
}

class ReviewDatum {
    DateTime? date;
    String? review;
    num? starNo;
    String? hospitalName;
    String? cusName;

    ReviewDatum({
        this.date,
        this.review,
        this.starNo,
        this.hospitalName,
        this.cusName,
    });

    factory ReviewDatum.fromJson(Map<String, dynamic> json) => ReviewDatum(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        review: json["review"],
        starNo: json["star_no"],
        hospitalName: json["hospital_name"],
        cusName: json["cus_name"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "review": review,
        "star_no": starNo,
        "hospital_name": hospitalName,
        "cus_name": cusName,
    };
}
