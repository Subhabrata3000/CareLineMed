import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());

class EditProfileModel {
  String message;
  bool status;
  UserData userData;

  EditProfileModel({
    required this.message,
    required this.status,
    required this.userData,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
    message: json["message"],
    status: json["status"],
    userData: UserData.fromJson(json["user_data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "user_data": userData.toJson(),
  };
}

class UserData {
  int id;
  String name;
  String email;
  String countryCode;
  String phone;
  String password;
  String role;
  String referralCode;
  String status;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.phone,
    required this.password,
    required this.role,
    required this.referralCode,
    required this.status,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    countryCode: json["country_code"],
    phone: json["phone"],
    password: json["password"],
    role: json["role"],
    referralCode: json["referral_code"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "country_code": countryCode,
    "phone": phone,
    "password": password,
    "role": role,
    "referral_code": referralCode,
    "status": status,
  };
}
