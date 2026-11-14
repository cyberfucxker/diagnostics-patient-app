// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

TestDetailModels welcomeFromJson(String str) =>
    TestDetailModels.fromJson(json.decode(str));

String welcomeToJson(TestDetailModels data) => json.encode(data.toJson());

class TestDetailModels {
  int status;
  String msg;
  TestDetailModelsList data;

  TestDetailModels({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory TestDetailModels.fromJson(Map<String, dynamic> json) =>
      TestDetailModels(
        status: json["status"],
        msg: json["msg"],
        data: TestDetailModelsList.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class TestDetailModelsList {
  int id;
  String profileName;
  String categoryId;
  String? branchId;
  String shortDesc;
  double? mrp;
  double? price;
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
  List<dynamic> review;
  Discount discount;
  int totalreview;
  dynamic avgreview;
  dynamic avgreview2;
  int? noOfParam;

  TestDetailModelsList({
    required this.id,
    required this.profileName,
    required this.categoryId,
    this.branchId,
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
    this.noOfParam,
    // required this.createdAt,
    // required this.updatedAt,
    required this.parameterList,
    required this.frqlist,
    required this.review,
    required this.discount,
    required this.totalreview,
    this.avgreview,
    this.avgreview2,
  });

  factory TestDetailModelsList.fromJson(Map<String, dynamic> json) =>
      TestDetailModelsList(
        id: json["id"] ?? null,
        profileName: json["profile_name"] ?? null,
        categoryId:
            json["category_id"] != null ? json["category_id"].toString() : '',
        branchId: json["branch_id"] != null ? json["branch_id"].toString() : '',
        shortDesc: json["short_desc"] != null ? json["short_desc"] : '',
        // int/double dono accept honge (num -> double)
        mrp: (json["mrp"] as num?)?.toDouble() ?? 0.0,
        price: (json["price"] as num?)?.toDouble() ?? 0.0,
        sampleCollection: (json["sample_collection"] as num?)?.toInt() ?? 0,
        sampleCollectionFee:
            (json["sample_collection_fee"] as num?)?.toInt() ?? 0,
        reportTime: json["report_time"] ?? '',
        fastingTime: (json["fasting_time"] as num?)?.toInt() ?? 0,
        fastTime: json["fast_time"] ?? '',
        testRecommendedFor: json["test_recommended_for"] ?? '',
        testRecommendedForAge: json["test_recommended_for_age"] ?? '',
        // string ya null dono handle
        description: json["description"] ?? '',
        noOfParameter: (json["no_of_parameter"] as num?)?.toInt() ?? 0,
        labReport: json["lab_report"] != null ? json["lab_report"] : '',
        deletedAt: json["deleted_at"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        parameterList: List<ParameterList>.from(
            json["parameter_list"].map((x) => ParameterList.fromJson(x))),
        frqlist:
            List<Frqlist>.from(json["frqlist"].map((x) => Frqlist.fromJson(x))),
        review: List<dynamic>.from(json["review"].map((x) => x)),
        discount: Discount.fromJson(json["discount"]),
        totalreview: (json["totalreview"] as num?)?.toInt() ?? 0,
        avgreview: json["avgreview"],
        avgreview2: json["avg_review"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_name": profileName,
        "category_id": categoryId,
        "branch_id": branchId,
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
        "parameter_list":
            List<dynamic>.from(parameterList.map((x) => x.toJson())),
        "frqlist": List<dynamic>.from(frqlist.map((x) => x.toJson())),
        "review": List<dynamic>.from(review.map((x) => x)),
        "discount": discount,
        "totalreview": totalreview,
        "avgreview": avgreview,
        "avg_review": avgreview2,
      };
}

class Frqlist {
  String question;
  String ans;

  Frqlist({
    required this.question,
    required this.ans,
  });

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
        per: (json["per"] as num?)?.toInt() ?? 0,
        fixed: (json["fixed"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "per": per,
        "fixed": fixed,
      };
}

class ParameterList {
  String name;
  int id;

  ParameterList({
    required this.name,
    required this.id,
  });

  factory ParameterList.fromJson(Map<String, dynamic> json) => ParameterList(
        name: json["name"] != null ? json["name"] : '',
        id: json["id"] != null ? json["id"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
