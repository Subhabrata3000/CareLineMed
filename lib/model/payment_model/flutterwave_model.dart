import 'dart:convert';

FlutterWaveModel flutterWaveModelFromJson(String str) => FlutterWaveModel.fromJson(json.decode(str));

String flutterWaveModelToJson(FlutterWaveModel data) => json.encode(data.toJson());

class FlutterWaveModel {
  String message;
  bool status;
  String flutterwaveUrl;

  FlutterWaveModel({
    required this.message,
    required this.status,
    required this.flutterwaveUrl,
  });

  factory FlutterWaveModel.fromJson(Map<String, dynamic> json) => FlutterWaveModel(
    message: json["message"],
    status: json["status"],
    flutterwaveUrl: json["FlutterwaveURL"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "FlutterwaveURL": flutterwaveUrl,
  };
}
