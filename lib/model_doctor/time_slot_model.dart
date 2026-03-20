import 'dart:convert';

TimeSlotModel timeSlotModelFromJson(String str) => TimeSlotModel.fromJson(json.decode(str));

String timeSlotModelToJson(TimeSlotModel data) => json.encode(data.toJson());

class TimeSlotModel {
  int responseCode;
  bool result;
  String message;
  Ndatelist ndatelist;

  TimeSlotModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.ndatelist,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) => TimeSlotModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    ndatelist: Ndatelist.fromJson(json["ndatelist"]),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "ndatelist": ndatelist.toJson(),
  };
}

class Ndatelist {
  String date;
  String weekDay;
  int avaiSlot;
  List<Afternoon> morning;
  List<Afternoon> afternoon;
  List<Afternoon> evening;

  Ndatelist({
    required this.date,
    required this.weekDay,
    required this.avaiSlot,
    required this.morning,
    required this.afternoon,
    required this.evening,
  });

  factory Ndatelist.fromJson(Map<String, dynamic> json) => Ndatelist(
    date: json["date"],
    weekDay: json["week_day"],
    avaiSlot: json["avai_slot"],
    morning: List<Afternoon>.from(json["Morning"].map((x) => Afternoon.fromJson(x))),
    afternoon: List<Afternoon>.from(json["Afternoon"].map((x) => Afternoon.fromJson(x))),
    evening: List<Afternoon>.from(json["Evening"].map((x) => Afternoon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "week_day": weekDay,
    "avai_slot": avaiSlot,
    "Morning": List<dynamic>.from(morning.map((x) => x.toJson())),
    "Afternoon": List<dynamic>.from(afternoon.map((x) => x.toJson())),
    "Evening": List<dynamic>.from(evening.map((x) => x.toJson())),
  };
}

class Afternoon {
  String t;
  int o;
  String hid;

  Afternoon({
    required this.t,
    required this.o,
    required this.hid,
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
