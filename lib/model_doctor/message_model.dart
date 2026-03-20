import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  int responseCode;
  bool result;
  String message;
  List<User> user;
  List<AllChat> allChat;

  MessageModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.user,
    required this.allChat,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    allChat: List<AllChat>.from(json["all_chat"].map((x) => AllChat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
    "all_chat": List<dynamic>.from(allChat.map((x) => x.toJson())),
  };
}

class AllChat {
  String date;
  List<Chat> chat;

  AllChat({
    required this.date,
    required this.chat,
  });

  factory AllChat.fromJson(Map<String, dynamic> json) => AllChat(
    date: json["date"],
    chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "chat": List<dynamic>.from(chat.map((x) => x.toJson())),
  };
}

class Chat {
  int id;
  String date;
  String message;
  int status;

  Chat({
    required this.id,
    required this.date,
    required this.message,
    required this.status,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    date: json["date"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "message": message,
    "status": status,
  };
}

class User {
  String logo;
  String name;

  User({
    required this.logo,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    logo: json["logo"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "logo": logo,
    "name": name,
  };
}
