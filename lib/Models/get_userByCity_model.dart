// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

GetUserCity getUserCityFromJson(String str) =>
    GetUserCity.fromJson(json.decode(str));

String getUserCityToJson(GetUserCity data) => json.encode(data.toJson());

class GetUserCity {
  List<GetUserByCityList> data;
  int status;
  String msg;

  GetUserCity({
    required this.data,
    required this.status,
    required this.msg,
  });

  factory GetUserCity.fromJson(Map<String, dynamic> json) => GetUserCity(
        data: List<GetUserByCityList>.from(
            json["data"].map((x) => GetUserByCityList.fromJson(x))),
        status: json["status"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "msg": msg,
      };
}

class GetUserByCityList {
  int id;
  String name;
  String phone;
  String profilePic;
  String email;
  dynamic dOB;
  dynamic age;
  dynamic sex;
  int userType;
  String city;
  String branchCode;
  String address;
  String companyName;
  String defaults;
  String description;
  String walletAmount;
  dynamic emailVerifiedAt;
  dynamic otp;
  String orderNotification;
  String loginType;
  dynamic soicalId;
  double lat;
  double lng;
  String? labName;
  // DateTime createdAt;
  // DateTime updatedAt;
  // dynamic deletedAt;

  GetUserByCityList({
    required this.id,
    required this.name,
    required this.phone,
    required this.profilePic,
    required this.email,
    this.dOB,
    this.age,
    this.sex,
    required this.userType,
    required this.defaults,
    required this.city,
    required this.branchCode,
    required this.address,
    required this.companyName,
    required this.lat,
    required this.lng,
    required this.description,
    required this.walletAmount,
    this.emailVerifiedAt,
    this.otp,
    required this.orderNotification,
    required this.loginType,
    this.soicalId,
    this.labName,
    // required this.createdAt,
    // required this.updatedAt,
    // this.deletedAt,
  });

  factory GetUserByCityList.fromJson(
          Map<String, dynamic> json) =>
      GetUserByCityList(
          id: json["id"],
          name: json["name"],
          phone: json["phone"] ?? '',
          profilePic: json["profile_pic"] ?? '',
          email: json["email"] ?? '',
          dOB: json["d_o_b"] ?? '',
          age: json["age"] ?? '',
          sex: json["sex"] ?? '',
          userType:
              json["user_type"] != null ? int.parse(json["user_type"]) : 0,
          city: json["city"] ?? '',
          branchCode: json["branch_code"] ?? '',
          address: json["address"] ?? '',
          defaults: json["default"] ?? '',
          companyName: json["company_name"] ?? '',
          description: json["description"] ?? '',
          walletAmount: json["wallet_amount"] ?? '',
          emailVerifiedAt: json["email_verified_at"],
          otp: json["otp"] ?? '',
          orderNotification: json["order_notification"] ?? '',
          loginType: json["login_type"] ?? '',
          lat: json["lat"]?.toDouble(),
          lng: json["lng"]?.toDouble(),
          soicalId: json["soical_id"] ?? '',
          labName: json['lab_name'] ?? ''
          // createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;,
          // updatedAt: DateTime.parse(json["updated_at"]),
          // deletedAt: json["deleted_at"],
          );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "profile_pic": profilePic,
        "email": email,
        "d_o_b": dOB,
        "age": age,
        "sex": sex,
        "user_type": userType,
        "city": city,
        "branch_code": branchCode,
        "address": address,
        "company_name": companyName,
        "description": description,
        "wallet_amount": walletAmount,
        "email_verified_at": emailVerifiedAt,
        "otp": otp,
        "default": defaults,
        "order_notification": orderNotification,
        "login_type": loginType,
        "lat": lat,
        "lng": lng,
        "soical_id": soicalId,
        'lab_name': labName,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        // "deleted_at": deletedAt,
      };
}
