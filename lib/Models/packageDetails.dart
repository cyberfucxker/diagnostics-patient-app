// To parse this JSON data, do
//
//     final packageDetailModel = packageDetailModelFromJson(jsonString);

import 'dart:convert';

PackageDetailModel packageDetailModelFromJson(String str) => PackageDetailModel.fromJson(json.decode(str));

String packageDetailModelToJson(PackageDetailModel data) => json.encode(data.toJson());

class PackageDetailModel {
  PackageDetailModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  Data data;

  factory PackageDetailModel.fromJson(Map<String, dynamic> json) => PackageDetailModel(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.shortDesc,
    // required this.categoryId,
    required this.description,
    required this.mrp,
    required this.price,
    this.paramterIncluded,
    required this.sampleCollection,
    this.sampleCollectionFee,
    required this.reportTime,
    required this.fastingTime,
    this.fastTime,
    required this.testRecommendedFor,
    required this.testRecommendedForAge,
    this.realtedPackage,
    required this.labReport,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.noOfParameter,
    required this.parameterList,
    required this.frqlist,
    required this.review,
    required this.totalreview,
    required this.avgreview,
    required this.discount,
  });

  int id;
  String name;
  String shortDesc;
  // int categoryId;
  String description;
  int mrp;
  int price;
  int? paramterIncluded;
  String sampleCollection;
  dynamic sampleCollectionFee;
  String reportTime;
  String fastingTime;
  dynamic fastTime;
  String testRecommendedFor;
  String testRecommendedForAge;
  dynamic realtedPackage;
  String labReport;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int noOfParameter;
  List<ParameterList> parameterList;
  List<Frq> frqlist;
  List<Review> review;
  Discount discount;
  int totalreview;
  String avgreview;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        shortDesc: json["short_desc"] != null ? json["short_desc"] : '',
        // categoryId: json["category_id"] ?? 0,
        description: json["description"],
        mrp: json["mrp"] != null ? json["mrp"].toInt() : 0,
        price: json["price"] != null ? json["price"].toInt() : 0,
        paramterIncluded: json["paramter_included"] ?? 0,
        sampleCollection: json["sample_collection"],
        sampleCollectionFee: json["sample_collection_fee"],
        reportTime: json["report_time"],
        fastingTime: json["fasting_time"].toString(),
        fastTime: json["fast_time"],
        testRecommendedFor: json["test_recommended_for"],
        testRecommendedForAge: json["test_recommended_for_age"],
        realtedPackage: json["realted_package"],
        labReport: json["lab_report"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        noOfParameter: json["no_of_parameter"] ?? 0,
        parameterList: List<ParameterList>.from(json["parameter_list"].map((x) => ParameterList.fromJson(x))),
        frqlist: List<Frq>.from(json["frqlist"].map((x) => Frq.fromJson(x))),
        review: List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        totalreview: json["totalreview"],
        discount: Discount.fromJson(json["discount"]),

        avgreview: json["avgreview"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_desc": shortDesc,
        // "category_id": categoryId,
        "description": description,
        "mrp": mrp,
        "price": price,
        "paramter_included": paramterIncluded,
        "sample_collection": sampleCollection,
        "sample_collection_fee": sampleCollectionFee,
        "report_time": reportTime,
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for": testRecommendedFor,
        "test_recommended_for_age": testRecommendedForAge,
        "realted_package": realtedPackage,
        "lab_report": labReport,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "no_of_parameter": noOfParameter,
        "discount": discount,
        "parameter_list": List<dynamic>.from(parameterList.map((x) => x.toJson())),
        "frqlist": List<Frq>.from(frqlist.map((x) => x.toJson())),
        "review": List<Review>.from(review.map((x) => x.toJson())),
        "totalreview": totalreview,
        "avgreview": avgreview,
      };
}

class ParameterList {
  ParameterList({
    required this.name,
    required this.id,
    required this.type,
    required this.parameter,
  });

  String name;
  int id;
  String type;
  List<Parameter> parameter;

  factory ParameterList.fromJson(Map<String, dynamic> json) => ParameterList(
        name: json["name"],
        id: json["id"],
        type: json["type"],
        parameter: List<Parameter>.from(json["parameter"].map((x) => Parameter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "type": type,
        "parameter": List<dynamic>.from(parameter.map((x) => x.toJson())),
      };
}

class Parameter {
  Parameter({
    required this.name,
    required this.id,
  });

  String name;
  int id;

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        name: json["name"] != null ? json["name"] : '',
        id: json["id"] != null ? json["id"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class Discount {
  int per;
  double fixed;

  Discount({
    required this.per,
    required this.fixed,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        per: json["per"],
        fixed: json["fixed"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "per": per,
        "fixed": fixed,
      };
}

class Frq {
  Frq({
    required this.question,
    required this.ans,
  });

  String question;
  String ans;

  factory Frq.fromJson(Map<String, dynamic> json) => Frq(
        question: json["question"],
        ans: json["ans"],
      );

  Map<String, dynamic> toJson() => {
        "ratting": question,
        "ans": ans,
      };
}

class Review {
  Review({
    required this.userId,
    required this.ratting,
    required this.date,
    required this.description,
    required this.username,
    required this.profilePic,
  });

  int userId;
  String ratting;
  String date;
  String description;
  String username;
  String profilePic;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["user_id"],
        ratting: json["ratting"],
        date: json["date"],
        description: json["description"],
        username: json["username"],
        profilePic: json["profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "ratting": ratting,
        "date": date,
        "description": description,
        "username": username,
        "profile_pic": profilePic,
      };
}
