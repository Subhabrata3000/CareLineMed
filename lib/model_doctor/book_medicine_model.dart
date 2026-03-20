import 'dart:convert';

BookMedicineListModel bookMedicineListModelFromJson(String str) => BookMedicineListModel.fromJson(json.decode(str));

String bookMedicineListModelToJson(BookMedicineListModel data) => json.encode(data.toJson());

class BookMedicineListModel {
  int responseCode;
  bool result;
  String message;
  List<DrugPresciption> drugPresciption;

  BookMedicineListModel({
    required this.responseCode,
    required this.result,
    required this.message,
    required this.drugPresciption,
  });

  factory BookMedicineListModel.fromJson(Map<String, dynamic> json) => BookMedicineListModel(
    responseCode: json["ResponseCode"],
    result: json["Result"],
    message: json["message"],
    drugPresciption: List<DrugPresciption>.from(json["drug_presciption"].map((x) => DrugPresciption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ResponseCode": responseCode,
    "Result": result,
    "message": message,
    "drug_presciption": List<dynamic>.from(drugPresciption.map((x) => x.toJson())),
  };
}

class DrugPresciption {
  int id;
  int mid;
  String days;
  String time;
  String type;
  String dosage;
  String frequency;
  String instructions;
  String medicineName;

  DrugPresciption({
    required this.id,
    required this.mid,
    required this.days,
    required this.time,
    required this.type,
    required this.dosage,
    required this.frequency,
    required this.instructions,
    required this.medicineName,
  });

  factory DrugPresciption.fromJson(Map<String, dynamic> json) => DrugPresciption(
    id: json["id"],
    mid: json["mid"],
    days: json["Days"],
    time: json["Time"],
    type: json["type"],
    dosage: json["Dosage"],
    frequency: json["Frequency"],
    instructions: json["Instructions"],
    medicineName: json["medicine_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mid": mid,
    "Days": days,
    "Time": time,
    "type": type,
    "Dosage": dosage,
    "Frequency": frequency,
    "Instructions": instructions,
    "medicine_name": medicineName,
  };
}
