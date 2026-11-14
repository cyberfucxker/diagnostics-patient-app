// // To parse this JSON data, do
// //
// //     final editProfileModel = editProfileModelFromJson(jsonString);
//
// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));
//
// String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());
//
// class EditProfileModel {
//   EditProfileModel({
//     required this.status,
//     required this.msg,
//     required this.data,
//   });
//
//   int status;
//   String msg;
//   Data data;
//
//   factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
//     status: json["status"],
//     msg: json["msg"],
//     data: Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "msg": msg,
//     "data": data.toJson(),
//   };
// }
//
// class Data {
//   Data({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.profilePic,
//     required this.email,
//     required this.userType,
//     required this.city,
//     required this.emailVerifiedAt,
//     required this.orderNotification,
//     required this.loginType,
//     required this.soicalId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.deletedAt,
//   });
//
//   int id;
//   String name;
//   int phone;
//   String profilePic;
//   String email;
//   int userType;
//   String city;
//   String emailVerifiedAt;
//   int orderNotification;
//   int loginType;
//   String soicalId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String deletedAt;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["id"],
//     name: json["name"],
//     phone: json["phone"],
//     profilePic: json["profile_pic"],
//     email: json["email"],
//     userType: json["user_type"],
//     city: json["city"].toString(),
//     emailVerifiedAt: json["email_verified_at"].toString(),
//     orderNotification: json["order_notification"],
//     loginType: json["login_type"],
//     soicalId: json["soical_id"].toString(),
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     deletedAt: json["deleted_at"].toString(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "phone": phone,
//     "profile_pic": profilePic,
//     "email": email,
//     "user_type": userType,
//     "city": city,
//     "email_verified_at": emailVerifiedAt,
//     "order_notification": orderNotification,
//     "login_type": loginType,
//     "soical_id": soicalId,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "deleted_at": deletedAt,
//   };
// }

// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromJson(jsonString);

import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());

class EditProfileModel {
  EditProfileModel({
    this.status,
    this.msg,
    this.data,
  });

  int? status;
  String? msg;
  Data? data;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.name,
    this.phone,
    this.profilePic,
    this.email,
    this.userType,
    this.city,
    this.emailVerifiedAt,
    this.orderNotification,
    this.loginType,
    this.soicalId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String ?name;
  int? phone;
  dynamic profilePic;
  String? email;
  int? userType;
  dynamic city;
  dynamic emailVerifiedAt;
  int? orderNotification;
  int? loginType;
  dynamic soicalId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    profilePic: json["profile_pic"],
    email: json["email"],
    userType: json["user_type"],
    city: json["city"],
    emailVerifiedAt: json["email_verified_at"],
    orderNotification: json["order_notification"],
    loginType: json["login_type"],
    soicalId: json["soical_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "profile_pic": profilePic,
    "email": email,
    "user_type": userType,
    "city": city,
    "email_verified_at": emailVerifiedAt,
    "order_notification": orderNotification,
    "login_type": loginType,
    "soical_id": soicalId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
