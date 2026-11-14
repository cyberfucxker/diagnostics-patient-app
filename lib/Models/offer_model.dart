// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

OfferModel welcomeFromJson(String str) => OfferModel.fromJson(json.decode(str));

String welcomeToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
  int status;
  String imagePath;
  String msg;
  List<OfferListModel> data;

  OfferModel({
    required this.status,
    required this.imagePath,
    required this.msg,
    required this.data,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        status: json["status"],
        imagePath: json["image_path"],
        msg: json["msg"],
        data: List<OfferListModel>.from(json["data"].map((x) => OfferListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "image_path": imagePath,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class OfferListModel {
  int id;
  String name;
  String image;
  String type;
  int typeId;
  DateTime createdAt;
  DateTime updatedAt;

  OfferListModel({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.typeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfferListModel.fromJson(Map<String, dynamic> json) => OfferListModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"] ?? '',
        typeId: json["type_id"] ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "type_id": typeId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
