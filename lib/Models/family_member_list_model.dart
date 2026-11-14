// To parse this JSON data, do
//
//     final familyMemberListModel = familyMemberListModelFromJson(jsonString);

import 'dart:convert';

FamilyMemberListModel familyMemberListModelFromJson(String str) => FamilyMemberListModel.fromJson(json.decode(str));

String familyMemberListModelToJson(FamilyMemberListModel data) => json.encode(data.toJson());

class FamilyMemberListModel {
  FamilyMemberListModel({
    this.status,
    this.msg,
    this.data,
  });

  int? status;
  String? msg;
  List<Datum>? data;

  factory FamilyMemberListModel.fromJson(Map<String, dynamic> json) => FamilyMemberListModel(
        status: json["status"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.mobileNo,
    this.age,
    this.email,
    this.dob,
    this.relation,
    this.gender,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.deletedAt,
    this.isSelected,
  });

  int? id;
  String? name;
  int? mobileNo;
  int? age;
  String? email;
  String? dob;
  String? relation;
  String? gender;
  int? userId;
  DateTime? updatedAt;
  DateTime? createdAt;
  dynamic deletedAt;
  bool? isSelected = false;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        mobileNo: json["mobile_no"],
        age: json["age"],
        email: json["email"],
        dob: json["dob"],
        // dob: DateTime.parse(convertDate(json["dob"])),
        relation: json["relation"],
        gender: json["gender"],
        userId: json["user_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        deletedAt: json["deleted_at"],
        isSelected: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile_no": mobileNo,
        "age": age,
        "email": email,
        // "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        // "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "dob": dob,
        "relation": relation,
        "gender": gender,
        "user_id": userId,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "isSelected": false,
      };
}

convertDate(value) {
  var splitValue = value.toString().split('-');
  var value1 = splitValue[2];
  var value2 = splitValue[1];
  var value3 = splitValue[0];

  return '$value1-$value2-$value3';
}
