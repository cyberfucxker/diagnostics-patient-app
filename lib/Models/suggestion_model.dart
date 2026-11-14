// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

SugesstionModel welcomeFromJson(String str) => SugesstionModel.fromJson(json.decode(str));

String welcomeToJson(SugesstionModel data) => json.encode(data.toJson());

class SugesstionModel {
  String status;
  String msg;
  List<String> data;

  SugesstionModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SugesstionModel.fromJson(Map<String, dynamic> json) => SugesstionModel(
        status: json["status"],
        msg: json["msg"],
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
