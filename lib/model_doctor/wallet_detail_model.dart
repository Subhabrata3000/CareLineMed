
import 'dart:convert';

WalletDetailModel walletDetailModelFromJson(String str) => WalletDetailModel.fromJson(json.decode(str));

String walletDetailModelToJson(WalletDetailModel data) => json.encode(data.toJson());

class WalletDetailModel {
  int responseCode;
  bool result;
  String message;
  num totBalance;
  List<WalletList> walletList;

  WalletDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.totBalance,
    required this.walletList,
  });

  factory WalletDetailModel.fromJson(Map<String, dynamic> json) => WalletDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    totBalance: json["tot_balance"],
    walletList: List<WalletList>.from(json["wallet_list"].map((x) => WalletList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "tot_balance": totBalance,
    "wallet_list": List<dynamic>.from(walletList.map((x) => x.toJson())),
  };
}

class WalletList {
  int id;
  String customerId;
  num amount;
  String date;
  String paymentType;
  String status;
  String amountType;
  String paymentName;

  WalletList({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.date,
    required this.paymentType,
    required this.status,
    required this.amountType,
    required this.paymentName,
  });

  factory WalletList.fromJson(Map<String, dynamic> json) => WalletList(
    id: json["id"],
    customerId: json["customer_id"],
    amount: json["amount"]?.toDouble(),
    date: json["date"],
    paymentType: json["payment_type"],
    status: json["status"],
    amountType: json["amount_type"],
    paymentName: json["payment_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "amount": amount,
    "date": date,
    "payment_type": paymentType,
    "status": status,
    "amount_type": amountType,
    "payment_name": paymentName,
  };
}
