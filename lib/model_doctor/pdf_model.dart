import 'dart:convert';

PdfModel pdfModelFromJson(String str) => PdfModel.fromJson(json.decode(str));

String pdfModelToJson(PdfModel data) => json.encode(data.toJson());

class PdfModel {
  int responseCode;
  bool result;
  String message;
  String pdfUrl;

  PdfModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.pdfUrl,
  });

  factory PdfModel.fromJson(Map<String, dynamic> json) => PdfModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    pdfUrl: json["pdf_URL"],
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "pdf_URL": pdfUrl,
  };
}
