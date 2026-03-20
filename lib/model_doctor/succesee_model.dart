import 'dart:convert';

SucceseeApiModel succeseeApiModelFromJson(String str) => SucceseeApiModel.fromJson(json.decode(str));

String succeseeApiModelToJson(SucceseeApiModel data) => json.encode(data.toJson());

class SucceseeApiModel {
  int responseCode;
  bool result;
  String message;
  AppointData appointData;
  String qrcode;

  SucceseeApiModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.appointData,
    required this.qrcode,
  });

  factory SucceseeApiModel.fromJson(Map<String, dynamic> json) => SucceseeApiModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    appointData: AppointData.fromJson(json["appoint_data"]),
    qrcode: json["qrcode"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "appoint_data": appointData.toJson(),
    "qrcode": qrcode,
  };
}

class AppointData {
  int id;
  String hospitalName;
  String departmentName;
  String subTitle;
  String bookDate;
  String appointmentDate;
  String appointmentTime;
  String dateType;
  String showType;
  num showTypePrice;
  num totPrice;
  num paidAmount;
  num additionalPrice;
  num couponAmount;
  num doctorCommission;
  num siteCommisiion;
  String paymentId;
  num walletAmount;
  String paymentImage;
  String paymentName;
  num onlineAmount;

  AppointData({
    required this.id,
    required this.hospitalName,
    required this.departmentName,
    required this.subTitle,
    required this.bookDate,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.dateType,
    required this.showType,
    required this.showTypePrice,
    required this.totPrice,
    required this.paidAmount,
    required this.additionalPrice,
    required this.couponAmount,
    required this.doctorCommission,
    required this.siteCommisiion,
    required this.paymentId,
    required this.walletAmount,
    required this.paymentImage,
    required this.paymentName,
    required this.onlineAmount,
  });

  factory AppointData.fromJson(Map<String, dynamic> json) => AppointData(
    id: json["id"],
    hospitalName: json["hospital_name"],
    departmentName: json["department_name"],
    subTitle: json["sub_title"],
    bookDate: json["book_date"],
    appointmentDate: json["appointment_date"],
    appointmentTime: json["appointment_time"],
    dateType: json["date_type"],
    showType: json["show_type"],
    showTypePrice: json["show_type_price"],
    totPrice: json["tot_price"],
    paidAmount: json["paid_amount"],
    additionalPrice: json["additional_price"],
    couponAmount: json["coupon_amount"],
    doctorCommission: json["doctor_commission"],
    siteCommisiion: json["site_commisiion"],
    paymentId: json["payment_id"],
    walletAmount: json["wallet_amount"],
    paymentImage: json["payment_image"],
    paymentName: json["payment_name"],
    onlineAmount: json["online_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "hospital_name": hospitalName,
    "department_name": departmentName,
    "sub_title": subTitle,
    "book_date": bookDate,
    "appointment_date": appointmentDate,
    "appointment_time": appointmentTime,
    "date_type": dateType,
    "show_type": showType,
    "show_type_price": showTypePrice,
    "tot_price": totPrice,
    "paid_amount": paidAmount,
    "additional_price": additionalPrice,
    "coupon_amount": couponAmount,
    "doctor_commission": doctorCommission,
    "site_commisiion": siteCommisiion,
    "payment_id": paymentId,
    "wallet_amount": walletAmount,
    "payment_image": paymentImage,
    "payment_name": paymentName,
    "online_amount": onlineAmount,
  };
}
