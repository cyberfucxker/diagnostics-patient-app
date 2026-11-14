// To parse this JSON data, do
//
//     final profileDetailModel = profileDetailModelFromJson(jsonString);

import 'dart:convert';

ProfileDetailModel profileDetailModelFromJson(String str) => ProfileDetailModel.fromJson(json.decode(str));

String profileDetailModelToJson(ProfileDetailModel data) => json.encode(data.toJson());

class ProfileDetailModel {
  ProfileDetailModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  ProfileModel data;

  factory ProfileDetailModel.fromJson(Map<String, dynamic> json) => ProfileDetailModel(
        status: json["status"],
        msg: json["msg"],
        data: ProfileModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class ProfileModel {
  ProfileModel({
    required this.id,
    required this.profileName,
    required this.categoryId,
    required this.shortDesc,
    required this.mrp,
    required this.price,
    required this.sampleCollection,
    required this.sampleCollectionFee,
    required this.reportTime,
    required this.fastingTime,
    required this.fastTime,
    required this.testRecommendedFor,
    required this.testRecommendedForAge,
    required this.description,
    required this.noOfParameter,
    required this.labReport,
    this.deletedAt,
    // required this.createdAt,
    // required this.updatedAt,
    required this.parameterList,
    required this.frqlist,
    required this.review,
    required this.discount,
    required this.totalreview,
    this.avgreview,
  });

  int id;
  String profileName;
  String categoryId;
  String shortDesc;
  int mrp;
  int price;
  int sampleCollection;
  int sampleCollectionFee;
  String reportTime;
  int fastingTime;
  String fastTime;
  String testRecommendedFor;
  String testRecommendedForAge;
  String description;
  int noOfParameter;
  String labReport;
  dynamic deletedAt;
  // DateTime createdAt;
  // DateTime updatedAt;
  List<ParameterList> parameterList;
  List<Frqlist> frqlist;
  List<Review> review;
  Discount discount;
  int totalreview;

  dynamic avgreview;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        profileName: json["profile_name"],
        categoryId: json["category_id"] != null ? json["category_id"].toString() : '',
        shortDesc: json["short_desc"] != null ? json["short_desc"] : '',
        mrp: json["mrp"] != null ? json["mrp"].toInt() : 0,
        price: json["price"] != null ? json["price"].toInt() : 0,
        sampleCollection: json["sample_collection"],
        sampleCollectionFee: json["sample_collection_fee"] ?? 0,
        reportTime: json["report_time"],
        fastingTime: json["fasting_time"],
        fastTime: json["fast_time"] ?? '',
        testRecommendedFor: json["test_recommended_for"],
        testRecommendedForAge: json["test_recommended_for_age"],
        description: json["description"],
        noOfParameter: json["no_of_parameter"],
        labReport: json["lab_report"] != null ? json["lab_report"] : '',
        deletedAt: json["deleted_at"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        parameterList: List<ParameterList>.from(json["parameter_list"].map((x) => ParameterList.fromJson(x))),
        frqlist: List<Frqlist>.from(json["frqlist"].map((x) => Frqlist.fromJson(x))),
        // review: List<dynamic>.from(json["review"].map((x) => x)),
        review: List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        totalreview: json["totalreview"],
        avgreview: json["avgreview"] ?? '0',
        discount: Discount.fromJson(json["discount"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_name": profileName,
        "category_id": categoryId,
        "short_desc": shortDesc,
        "mrp": mrp,
        "price": price,
        "sample_collection": sampleCollection,
        "sample_collection_fee": sampleCollectionFee,
        "report_time": reportTime,
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for": testRecommendedFor,
        "test_recommended_for_age": testRecommendedForAge,
        "description": description,
        "no_of_parameter": noOfParameter,
        "lab_report": labReport,
        "deleted_at": deletedAt,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "parameter_list": List<dynamic>.from(parameterList.map((x) => x.toJson())),
        "frqlist": List<dynamic>.from(frqlist.map((x) => x.toJson())),
        // "review": List<dynamic>.from(review.map((x) => x)),
        "review": List<Review>.from(review.map((x) => x.toJson())),
        "totalreview": totalreview,
        "avgreview": avgreview,
      };
}

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

class ParameterList {
  ParameterList({
    required this.name,
    required this.id,
    this.type,
    this.parameter,
  });

  String name;
  int id;
  String? type;
  List<Parameter>? parameter;

  factory ParameterList.fromJson(Map<String, dynamic> json) => ParameterList(
        name: json["name"] != null ? json["name"] : '',
        id: json["id"] != null ? json["id"] : 0,
        type: json["type"] != null ? json["type"] : '',
        parameter: (json["parameter"] != null) ? List<Parameter>.from(json["parameter"].map((x) => Parameter.fromJson(x))) : [],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "type": type,
        "parameter": List<dynamic>.from(parameter!.map((x) => x.toJson())),
      };
}

class Parameter {
  Parameter({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        name: json["name"] != null ? json["name"] : '',
        id: json["id"] != null ? json["id"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
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
