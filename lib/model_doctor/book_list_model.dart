import 'dart:convert';

BookListModel bookListModelFromJson(String str) => BookListModel.fromJson(json.decode(str));

String bookListModelToJson(BookListModel data) => json.encode(data.toJson());

class BookListModel {
  int responseCode;
  bool result;
  String message;
  List<AppointList> pendingAppointList;
  List<AppointList> completeAppointList;

  BookListModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.pendingAppointList,
    required this.completeAppointList,
  });

  factory BookListModel.fromJson(Map<String, dynamic> json) => BookListModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    pendingAppointList: List<AppointList>.from(json["pending_appoint_list"].map((x) => AppointList.fromJson(x))),
    completeAppointList: List<AppointList>.from(json["complete_appoint_list"].map((x) => AppointList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "pending_appoint_list": List<dynamic>.from(pendingAppointList.map((x) => x.toJson())),
    "complete_appoint_list": List<dynamic>.from(completeAppointList.map((x) => x.toJson())),
  };
}

class AppointList {
  int id;
  int did;
  String docLogo;
  String docTitle;
  String departName;
  String bookDate;
  String appointmentDate;
  String appointmentTime;
  num totPrice;
  String showType;
  String name;
  String countryCode;
  String phone;
  String statusType;

  AppointList({
    required this.id,
    required this.did,
    required this.docLogo,
    required this.docTitle,
    required this.departName,
    required this.bookDate,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.totPrice,
    required this.showType,
    required this.name,
    required this.countryCode,
    required this.phone,
    required this.statusType,
  });

  factory AppointList.fromJson(Map<String, dynamic> json) => AppointList(
    id: json["id"],
    did: json["did"],
    docLogo: json["doc_logo"],
    docTitle: json["doc_title"],
    departName: json["depart_name"],
    bookDate: json["book_date"],
    appointmentDate: json["appointment_date"],
    appointmentTime: json["appointment_time"],
    totPrice: json["tot_price"],
    showType: json["show_type"],
    name: json["name"],
    countryCode: json["country_code"],
    phone: json["phone"],
    statusType: json["status_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "did": did,
    "doc_logo": docLogo,
    "doc_title": docTitle,
    "depart_name": departName,
    "book_date": bookDate,
    "appointment_date": appointmentDate,
    "appointment_time": appointmentTime,
    "tot_price": totPrice,
    "show_type": showType,
    "name": name,
    "country_code": countryCode,
    "phone": phone,
    "status_type": statusType,
  };
}
