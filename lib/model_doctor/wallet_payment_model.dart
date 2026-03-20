import 'dart:convert';

WalletPaymentDetailModel walletPaymentDetailModelFromJson(String str) => WalletPaymentDetailModel.fromJson(json.decode(str));

String walletPaymentDetailModelToJson(WalletPaymentDetailModel data) => json.encode(data.toJson());

class WalletPaymentDetailModel {
  int responseCode;
  bool result;
  String message;
  List<PaymentList> paymentList;

  WalletPaymentDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.paymentList,
  });

  factory WalletPaymentDetailModel.fromJson(Map<String, dynamic> json) => WalletPaymentDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    paymentList: List<PaymentList>.from(json["payment_list"].map((x) => PaymentList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "payment_list": List<dynamic>.from(paymentList.map((x) => x.toJson())),
  };
}

class PaymentList {
  int id;
  String image;
  String name;
  String subTitle;
  String attribute;
  String status;
  String walletStatus;

  PaymentList({
    required this.id,
    required this.image,
    required this.name,
    required this.subTitle,
    required this.attribute,
    required this.status,
    required this.walletStatus,
  });

  factory PaymentList.fromJson(Map<String, dynamic> json) => PaymentList(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    subTitle: json["sub_title"],
    attribute: json["attribute"],
    status: json["status"],
    walletStatus: json["wallet_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "sub_title": subTitle,
    "attribute": attribute,
    "status": status,
    "wallet_status": walletStatus,
  };
}
