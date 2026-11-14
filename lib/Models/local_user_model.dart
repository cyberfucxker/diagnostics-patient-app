// To parse this JSON data, do
//
//     final localUserModel = localUserModelFromJson(jsonString);

import 'dart:convert';

List <LocalUserModel> localUserModelFromJson(String str) => List<LocalUserModel>.from(json.decode(str).map((x) => LocalUserModel.fromJson(x)));

// LocalUserModel localUserModelFromJson(String str) => LocalUserModel.fromJson(json.decode(str));
String localUserModelToJson(List<LocalUserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// String localUserModelToJson(LocalUserModel data) => json.encode(data.toJson());

class LocalUserModel {
  LocalUserModel({
    this.id,
    this.userId,
    this.userName,
    this.userGender,
    this.userAge,
    this.userRelation,
  });

  int? id;
  int? userId;
  String? userName;
  String? userGender;
  String? userAge;
  String? userRelation;

  factory LocalUserModel.fromJson(Map<String, dynamic> json) => LocalUserModel(
    id: json["id"],
    userId: json["userId"],
    userName: json["userName"],
    userGender: json["userGender"],
    userAge: json["userAge"],
    userRelation: json["userRelation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "userName": userName,
    "userGender": userGender,
    "userAge": userAge,
    "userRelation": userRelation,
  };
}
