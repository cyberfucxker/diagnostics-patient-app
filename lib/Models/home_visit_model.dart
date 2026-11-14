// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);

// import 'dart:convert';

// HomeVisitModel welcomeFromJson(String str) => HomeVisitModel.fromJson(json.decode(str));

// String welcomeToJson(HomeVisitModel data) => json.encode(data.toJson());

// class HomeVisitModel {
//   int status;
//   String msg;
//   List<HomeVisitModelList> data;

//   HomeVisitModel({
//     required this.status,
//     required this.msg,
//     required this.data,
//   });

//   factory HomeVisitModel.fromJson(Map<String, dynamic> json) => HomeVisitModel(
//         status: json["status"],
//         msg: json["msg"],
//         data: List<HomeVisitModelList>.from(json["data"].map((x) => HomeVisitModelList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "msg": msg,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class HomeVisitModelList {
//   int id;
//   int labId;
//   int userId;
//   String userName;
//   int userNumber;
//   String userEmail;
//   int cityId;
//   double lat;
//   double lng;
//   String state;
//   int pincode;
//   int status;
//   DateTime createdAt;
//   DateTime updatedAt;

//   HomeVisitModelList({
//     required this.id,
//     required this.labId,
//     required this.userId,
//     required this.userName,
//     required this.userNumber,
//     required this.userEmail,
//     required this.cityId,
//     required this.lat,
//     required this.lng,
//     required this.state,
//     required this.pincode,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory HomeVisitModelList.fromJson(Map<String, dynamic> json) => HomeVisitModelList(
//         id: json["id"],
//         labId: json["lab_id"],
//         userId: json["user_id"],
//         userName: json["user_name"],
//         userNumber: json["user_number"],
//         userEmail: json["user_email"],
//         cityId: json["city_id"],
//         lat: json["lat"]?.toDouble(),
//         lng: json["lng"]?.toDouble(),
//         state: json["state"],
//         pincode: json["pincode"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "lab_id": labId,
//         "user_id": userId,
//         "user_name": userName,
//         "user_number": userNumber,
//         "user_email": userEmail,
//         "city_id": cityId,
//         "lat": lat,
//         "lng": lng,
//         "state": state,
//         "pincode": pincode,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

HomeVisitModel welcomeFromJson(String str) =>
    HomeVisitModel.fromJson(json.decode(str));

String welcomeToJson(HomeVisitModel data) => json.encode(data.toJson());

class HomeVisitModel {
  int status;
  String msg;
  List<HomeVisitModelList> data;

  HomeVisitModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory HomeVisitModel.fromJson(Map<String, dynamic> json) => HomeVisitModel(
        status: json["status"],
        msg: json["msg"],
        data: List<HomeVisitModelList>.from(
            json["data"].map((x) => HomeVisitModelList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HomeVisitModelList {
  int id;
  int labId;
  int userId;
  String userName;
  int userNumber;
  String userEmail;
  int cityId;
  double lat;
  double lng;
  String state;
  int pincode;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  Citydata? citydata;
  Lab? lab;

  HomeVisitModelList({
    required this.id,
    required this.labId,
    required this.userId,
    required this.userName,
    required this.userNumber,
    required this.userEmail,
    required this.cityId,
    required this.lat,
    required this.lng,
    required this.state,
    required this.pincode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.citydata,
    this.lab,
  });

  factory HomeVisitModelList.fromJson(Map<String, dynamic> json) =>
      HomeVisitModelList(
        id: json["id"],
        labId: json["lab_id"] != null ? json["lab_id"] : 0,
        userId: json["user_id"],
        userName: json["user_name"],
        userNumber: json["user_number"],
        userEmail: json["user_email"],
        cityId: json["city_id"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        state: json["state"],
        pincode: json["pincode"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        citydata: json["citydata"] == null
            ? null
            : Citydata.fromJson(json["citydata"]),
        lab: json["lab"] == null ? null : Lab.fromJson(json["lab"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lab_id": labId,
        "user_id": userId,
        "user_name": userName,
        "user_number": userNumber,
        "user_email": userEmail,
        "city_id": cityId,
        "lat": lat,
        "lng": lng,
        "state": state,
        "pincode": pincode,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "citydata": citydata?.toJson(),
        "lab": lab?.toJson(),
      };
}

class Citydata {
  int id;
  String name;
  double lat;
  double lng;
  int isDeleted;
  String createdAt;
  String updatedAt;

  Citydata({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Citydata.fromJson(Map<String, dynamic> json) => Citydata(
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

class Lab {
  int id;
  String name;
  // dynamic phone;
  // String profilePic;
  String email;
  // dynamic dOB;
  // dynamic age;
  // dynamic sex;
  int userType;
  int city;
  String branchCode;
  String address;
  String companyName;
  String description;
  int walletAmount;
  // dynamic emailVerifiedAt;
  // dynamic otp;
  int orderNotification;
  int loginType;
  // dynamic soicalId;
  DateTime createdAt;
  DateTime updatedAt;
  // dynamic deletedAt;

  Lab({
    required this.id,
    required this.name,
    // this.phone,
    // required this.profilePic,
    required this.email,
    // this.dOB,
    // this.age,
    // this.sex,
    required this.userType,
    required this.city,
    required this.branchCode,
    required this.address,
    required this.companyName,
    required this.description,
    required this.walletAmount,
    // this.emailVerifiedAt,
    // this.otp,
    required this.orderNotification,
    required this.loginType,
    // this.soicalId,
    required this.createdAt,
    required this.updatedAt,
    // this.deletedAt,
  });

  /* factory Lab.fromJson(Map<String, dynamic> json) => Lab(
        id: json["id"],
        name: json["name"] ?? "",
        // phone: json["phone"] != null ? json["phone"] : '',
        // profilePic: json["profile_pic"] ?? null,
        email: json["email"],
        // dOB: json["d_o_b"] != null ? json["d_o_b"] : '',
        // age: json["age"],
        // sex: json["sex"],
        userType: json["user_type"],
        city: json["city"] != null ? json["city"] : 0,
        branchCode: json["branch_code"] != null ? json["branch_code"] : '',
        address: json["address"] != null ? json["address"] : '',
        companyName: json["company_name"] != null ? json["company_name"] : '',
        description: json["description"] != null ? json["description"] : '',
        walletAmount: json["wallet_amount"] != null ? json["wallet_amount"] : 0,
        // emailVerifiedAt: json["email_verified_at"],
        // otp: json["otp"],
        orderNotification: json["order_notification"] != null ? json["order_notification"] : '',
        loginType: json["login_type"] != null ? json["login_type"] : 0,
        // soicalId: json["soical_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        // deletedAt: json["deleted_at"],
      ); */
  factory Lab.fromJson(Map<String, dynamic> json) => Lab(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        userType: json["user_type"] ?? 0,
        city: json["city"] ?? 0,
        branchCode: json["branch_code"] ?? "",
        address: json["address"] ?? "",
        companyName: json["company_name"] ?? "",
        description: json["description"] ?? "",
        walletAmount: json["wallet_amount"] ?? 0,
        orderNotification: json["order_notification"] ?? 0,
        loginType: json["login_type"] ?? 0,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "phone": phone,
        // "profile_pic": profilePic,
        "email": email,
        // "d_o_b": dOB,
        // "age": age,
        // "sex": sex,
        "user_type": userType,
        "city": city,
        "branch_code": branchCode,
        "address": address,
        "company_name": companyName,
        "description": description,
        "wallet_amount": walletAmount,
        // "email_verified_at": emailVerifiedAt,
        // "otp": otp,
        "order_notification": orderNotification,
        "login_type": loginType,
        // "soical_id": soicalId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        // "deleted_at": deletedAt,
      };
}
