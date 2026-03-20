import 'dart:convert';

ChatDetailModel chatDetailModelFromJson(String str) => ChatDetailModel.fromJson(json.decode(str));

String chatDetailModelToJson(ChatDetailModel data) => json.encode(data.toJson());

class ChatDetailModel {
  int responseCode;
  bool result;
  String message;
  List<ChatList> chatList;

  ChatDetailModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.chatList,
  });

  factory ChatDetailModel.fromJson(Map<String, dynamic> json) => ChatDetailModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    chatList: List<ChatList>.from(json["chat_list"].map((x) => ChatList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "chat_list": List<dynamic>.from(chatList.map((x) => x.toJson())),
  };
}

class ChatList {
  int id;
  String senderId;
  String receiverId;
  String date;
  String message;
  String logo;
  String name;
  String status;

  ChatList({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.date,
    required this.message,
    required this.logo,
    required this.name,
    required this.status,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
    id: json["id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    date: json["date"],
    message: json["message"],
    logo: json["logo"],
    name: json["name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "date": date,
    "message": message,
    "logo": logo,
    "name": name,
    "status": status,
  };
}
