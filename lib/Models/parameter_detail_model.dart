// To parse this JSON data, do
//
//     final parameterDetailModel = parameterDetailModelFromJson(jsonString);

import 'dart:convert';

ParameterDetailModel parameterDetailModelFromJson(String str) =>
    ParameterDetailModel.fromJson(json.decode(str));

String parameterDetailModelToJson(ParameterDetailModel data) =>
    json.encode(data.toJson());

class ParameterDetailModel {
  ParameterDetailModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  ParameterModel data;

  factory ParameterDetailModel.fromJson(Map<String, dynamic> json) =>
      ParameterDetailModel(
        status: json["status"],
        msg: json["msg"],
        data: ParameterModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class ParameterModel {
  ParameterModel({
    this.id,
    this.name,
    this.shortDesc,
    this.description,
    this.mrp,
    this.price,
    this.sampleCollection,
    this.sampleCollectionFee,
    this.reportTime,
    this.fastingTime,
    this.fastTime,
    this.testRecommendedFor,
    this.testRecommendedForAge,
    this.labReport,
    this.deletedAt,
    this.frqlist,
    this.review,
    this.totalreview,
    this.discount,
    this.avgreview,
    this.registrationRequired,
  });

  int? id;
  String? name;
  String? shortDesc;
  String? description;
  double? mrp;
  double? price;
  int? sampleCollection;
  dynamic sampleCollectionFee;
  String? reportTime;
  int? fastingTime;
  dynamic fastTime;
  String? testRecommendedFor;
  String? testRecommendedForAge;
  String? labReport;
  dynamic deletedAt;
  List<Frqlist>? frqlist;
  List<Review>? review;
  int? totalreview;
  Discount? discount;
  dynamic avgreview;
  int? registrationRequired;

  factory ParameterModel.fromJson(Map<String, dynamic> json) => ParameterModel(
        id: json["id"],
        name: json["name"],
        shortDesc: json["short_desc"],
        description: json["description"],
        mrp: double.parse(json["mrp"].toString()),
        price: double.parse(json["price"].toString()),
        sampleCollection: json["sample_collection"],
        sampleCollectionFee: json["sample_collection_fee"],
        reportTime: json["report_time"],
        fastingTime: json["fasting_time"],
        fastTime: json["fast_time"],
        testRecommendedFor: json["test_recommended_for"],
        testRecommendedForAge: json["test_recommended_for_age"],
        labReport: json["lab_report"],
        deletedAt: json["deleted_at"],
        frqlist: json["frqlist"] != null
            ? List<Frqlist>.from(
                json["frqlist"].map((x) => Frqlist.fromJson(x)))
            : null,
        review: json["review"] != null
            ? List<Review>.from(json["review"].map((x) => Review.fromJson(x)))
            : null,
        totalreview: json["totalreview"],
        discount: json["discount"] != null
            ? Discount.fromJson(json["discount"])
            : null,
        avgreview: json["avgreview"],
        registrationRequired:
            (json["registration_required"] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_desc": shortDesc,
        "description": description,
        "mrp": mrp,
        "price": price,
        "sample_collection": sampleCollection,
        "sample_collection_fee": sampleCollectionFee,
        "report_time": reportTime,
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for": testRecommendedFor,
        "test_recommended_for_age": testRecommendedForAge,
        "lab_report": labReport,
        "deleted_at": deletedAt,
        "frqlist": frqlist?.map((x) => x.toJson()).toList(),
        "review": review?.map((x) => x.toJson()).toList(),
        "totalreview": totalreview,
        "discount": discount?.toJson(),
        "avgreview": avgreview,
        "registration_required": registrationRequired,
      };
}

/* class ParameterModel {
  ParameterModel({
    required this.id,
    required this.name,
    // required this.categoryId,
    required this.shortDesc,
    required this.description,
    required this.mrp,
    required this.price,
    required this.sampleCollection,
    required this.sampleCollectionFee,
    required this.reportTime,
    required this.fastingTime,
    required this.fastTime,
    required this.testRecommendedFor,
    required this.testRecommendedForAge,
    required this.labReport,
    this.deletedAt,
    // required this.createdAt,
    // required this.updatedAt,
    required this.frqlist,
    required this.review,
    required this.totalreview,
    required this.discount,
    this.avgreview,
  });

  int id;
  String name;
  // int categoryId;
  String shortDesc;
  String description;
  int mrp;
  int price;
  int sampleCollection;
  dynamic sampleCollectionFee;
  String reportTime;
  int fastingTime;
  dynamic fastTime;
  String testRecommendedFor;
  String testRecommendedForAge;
  String labReport;
  dynamic deletedAt;
  // DateTime createdAt;
  // DateTime updatedAt;
  List<Frqlist> frqlist;
  // List<dynamic> review;
  List<Review> review;
  Discount discount;
  int totalreview;

  dynamic avgreview;

  factory ParameterModel.fromJson(Map<String, dynamic> json) => ParameterModel(
        id: json["id"],
        name: json["name"],
        // categoryId: json["category_id"] != null ? int.parse(json["category_id"].toString()) : 0,
        shortDesc: json["short_desc"] != null ? json["short_desc"] : '',
        description: json["description"],
        mrp: json["mrp"] != null ? json["mrp"].toInt() : 0,
        price: json["price"] != null ? json["price"].toInt() : 0,
        sampleCollection: json["sample_collection"],
        sampleCollectionFee: json["sample_collection_fee"],
        reportTime: json["report_time"],
        fastingTime: json["fasting_time"],
        fastTime: json["fast_time"],
        testRecommendedFor: json["test_recommended_for"],
        testRecommendedForAge: json["test_recommended_for_age"],
        labReport: json["lab_report"] != null ? json["lab_report"] : '',
        deletedAt: json["deleted_at"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        frqlist:
            List<Frqlist>.from(json["frqlist"].map((x) => Frqlist.fromJson(x))),
        // review: List<dynamic>.from(json["review"].map((x) => x)),
        review:
            List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        totalreview: json["totalreview"],
        discount: Discount.fromJson(json["discount"]),
        avgreview: json["avgreview"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        // "category_id": categoryId,
        "short_desc": shortDesc,
        "description": description,
        "mrp": mrp,
        "price": price,
        "sample_collection": sampleCollection,
        "sample_collection_fee": sampleCollectionFee,
        "report_time": reportTime,
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for": testRecommendedFor,
        "test_recommended_for_age": testRecommendedForAge,
        "lab_report": labReport,
        "deleted_at": deletedAt,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "frqlist": List<dynamic>.from(frqlist.map((x) => x.toJson())),
        // "review": List<dynamic>.from(review.map((x) => x)),
        "review": List<Review>.from(review.map((x) => x.toJson())),
        "totalreview": totalreview,
        "discount": discount,
        "avgreview": avgreview,
      };
} */

class Frqlist {
  Frqlist({
    required this.question,
    required this.ans,
  });

  String question;
  String ans;

  factory Frqlist.fromJson(Map<String, dynamic> json) => Frqlist(
        question: json["question"],
        ans: json["ans"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "ans": ans,
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
