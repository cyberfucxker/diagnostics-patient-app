import 'dart:convert';

LabModel popularPackageFromJson(String str) => LabModel.fromJson(json.decode(str));

String popularPackageToJson(LabModel data) => json.encode(data.toJson());

class LabModel {
  LabModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  List<LabModelList> data;

  factory LabModel.fromJson(Map<String, dynamic> json) => LabModel(
        status: json["status"],
        msg: json["msg"],
        data: List<LabModelList>.from(json["data"]['data'].map((x) => LabModelList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class LabModelList {
  int? id;
  String? name;
  String? phone;
  String? profilePic;
  String? email;
  String? dOB;
  String? age;
  String? sex;
  int? userType;
  int? city;
  String? branchCode;
  String? address;
  String? companyName;
  String? description;
  String? emailVerifiedAt;
  int? orderNotification;
  int? loginType;
  String? soicalId;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? lat;
  double? lng;
  double? distance;
  Location? location;

  LabModelList({
    this.id,
    this.name,
    this.phone,
    this.profilePic,
    this.email,
    this.dOB,
    this.age,
    this.sex,
    this.userType,
    this.city,
    this.branchCode,
    this.address,
    this.companyName,
    this.description,
    this.emailVerifiedAt,
    this.orderNotification,
    this.loginType,
    this.soicalId,
    this.createdAt,
    this.updatedAt,
    this.lat,
    this.lng,
    this.distance,
    this.location,
  });

  LabModelList.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      name = json["name"];
      phone = json["phone"] != null ? json["phone"].toString() : '';
      profilePic = json["profile_pic"];
      email = json["email"];
      dOB = json["d_o_b"];
      age = json["age"];
      sex = json["sex"];
      userType = json["user_type"];
      city = json["city"];
      branchCode = json["branch_code"];
      address = json["address"];
      companyName = json["company_name"];
      description = json["description"];
      emailVerifiedAt = json["email_verified_at"];
      orderNotification = json["order_notification"];
      loginType = json["login_type"];
      soicalId = json["soical_id"];
      // createdAt: DateTime.parse(json["created_at"]) != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
      createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
      updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()).toLocal() : null;
      lat = json["lat"] != null ? double.parse(json["lat"].toString()) : 0.0;
      lng = json["lng"] != null ? double.parse(json["lng"].toString()) : 0.0;
      distance = json["distance"] != null ? double.parse(json["distance"].toString()) : 0.0;
      location = json["location"] != null ? Location.fromJson(json["location"]) : null;
    } catch (e) {
      print('Exceptin : lab_model.dart - LabModelList.fromJson()' + e.toString());
    }
  }

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
        "email_verified_at": emailVerifiedAt,
        "order_notification": orderNotification,
        "login_type": loginType,
        "soical_id": soicalId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "lat": lat,
        "lng": lng,
        "distance": distance,
        "location": location!.toJson(),
      };
}

class Location {
  int? id;
  String? name;
  double? lat;
  double? lng;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  Location({
    this.id,
    this.name,
    this.lat,
    this.lng,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lat": lat,
        "lng": lng,
        "is_deleted": isDeleted,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
