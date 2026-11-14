// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

PrescriptionModel prescriptionFromJson(String str) => PrescriptionModel.fromJson(json.decode(str));

String prescriptionToJson(PrescriptionModel data) => json.encode(data.toJson());

class PrescriptionModel {
  int status;
  String imagePath;
  String msg;
  List<PrecriptionList> data;

  PrescriptionModel({
    required this.status,
    required this.imagePath,
    required this.msg,
    required this.data,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) => PrescriptionModel(
        status: json["status"],
        imagePath: json["image_path"],
        msg: json["msg"],
        data: List<PrecriptionList>.from(json["data"].map((x) => PrecriptionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "image_path": imagePath,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PrecriptionList {
  int id;
  int locationId;
  String prescription;
  int userId;
  String name;
  String email;
  String gender;
  String dOB;
  int number;
  int isAgree;
  // DateTime createdAt;
  // DateTime updatedAt;
  Location location;

  PrecriptionList({
    required this.id,
    required this.locationId,
    required this.prescription,
    required this.userId,
    required this.name,
    required this.email,
    required this.gender,
    required this.dOB,
    required this.number,
    required this.isAgree,
    // required this.createdAt,
    // required this.updatedAt,
    required this.location,
  });

  factory PrecriptionList.fromJson(Map<String, dynamic> json) => PrecriptionList(
        id: json["id"],
        locationId: json["location_id"],
        prescription: json["prescription"] != null ? json["prescription"] : '',
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        gender: json["gender"],
        dOB: json["d_o_b"],
        number: json["number"],
        isAgree: json["is_agree"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        location: Location.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_id": locationId,
        "prescription": prescription,
        "user_id": userId,
        "name": name,
        "email": email,
        "gender": gender,
        "d_o_b": dOB,
        "number": number,
        "is_agree": isAgree,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "location": location.toJson(),
      };
}

class Location {
  int id;
  String name;
  double lat;
  double lng;
  int isDeleted;
  String createdAt;
  String updatedAt;

  Location({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lat": lat,
        "lng": lng,
        "is_deleted": isDeleted,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
