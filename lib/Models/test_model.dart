import 'dart:convert';

TestModel popularPackageFromJson(String str) => TestModel.fromJson(json.decode(str));

String popularPackageToJson(TestModel data) => json.encode(data.toJson());

class TestModel {
  TestModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  int status;
  String msg;
  List<TestListModel> data;

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        status: json["status"],
        msg: json["msg"],
        data: List<TestListModel>.from(json["data"].map((x) => TestListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TestListModel {
  TestListModel(
      {this.id,
      this.profileName,
      // this.categoryId,
      this.branchId,
      this.shortDesc,
      this.testShortCode,
      this.mrp,
      this.price,
      this.sampleCollection,
      this.sampleCollectionFee,
      this.reportTime,
      this.fastingTime,
      this.fastTime,
      this.testRecommendedFor,
      // this.testRecommendedForAge,
      this.description,
      this.noOfParameter,
      this.labReport,
      // this.createdAt,
      // this.updatedAt,
      this.paramaterData,
      required this.discount,
      this.countOfParamas,
      this.noOfTest});

  int? id;
  String? profileName;
  // String? categoryId;
  String? testShortCode;
  List<String>? branchId;
  String? shortDesc;
  int? mrp;
  double? price;
  int? sampleCollection;
  int? sampleCollectionFee;
  String? reportTime;
  int? fastingTime;
  int? noOfTest;
  String? fastTime;
  String? testRecommendedFor;
  // String? testRecommendedForAge;
  String? description;
  String? noOfParameter;
  String? labReport;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  List<String>? paramaterData;
  Discount discount;
  int? countOfParamas;

  factory TestListModel.fromJson(Map<String, dynamic> json) => TestListModel(
        id: json["id"],
        profileName: json["profile_name"],
        testShortCode: json["test_short_code"] != null ? json["test_short_code"] : '',
        // categoryId: json["category_id"] != null ? int.parse(json["category_id"]).toString() : '',
        branchId: json["branch_id"].runtimeType == int ? [json["branch_id"].toString()] : json["branch_id"].toString().split(','),
        shortDesc: json["short_desc"],
        mrp: json["mrp"] != null ? int.parse(json["mrp"].toString().split('.')[0]) : null,
        price: json["price"] != null ? double.parse(json["price"].toString()) : 0.0,
        sampleCollection: json["sample_collection"] != null ? int.parse(json["sample_collection"].toString().split('.')[0]) : null,
        sampleCollectionFee: json["sample_collection_fee"] != null ? int.parse(json["sample_collection_fee"].toString().split('.')[0]) : null,
        reportTime: json["report_time"],
        fastingTime: json["fasting_time"] != null ? int.parse(json["fasting_time"].toString()) : null,
        fastTime: json["fast_time"],
        testRecommendedFor: json["test_recommended_for"],
        // testRecommendedForAge: json["test_recommended_for_age"] ?? '',
        description: json["description"],
        noOfTest: json["no_of_test"] != null ? int.parse(json["no_of_test"].toString()) : 0,
        noOfParameter: json["no_of_parameter"] == null ? json["no_of_parameter"] : json["no_of_parameter"].toString(),
        labReport: json["lab_report"] != null ? json["lab_report"] : '',
        discount: Discount.fromJson(json["discount"]),
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        paramaterData: json["paramater_data"] != null ? List<String>.from(json["paramater_data"].map((x) => x)) : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_name": profileName,
        // "category_id": categoryId,
        "branch_id": branchId,
        "short_desc": shortDesc,
        "mrp": mrp,
        "test_short_code": testShortCode,
        "price": price,
        "sample_collection": sampleCollection,
        "sample_collection_fee": sampleCollectionFee,
        "report_time": reportTime,
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for": testRecommendedFor,
        // "test_recommended_for_age": testRecommendedForAge,
        "description": description,
        "no_of_parameter": noOfParameter,
        "lab_report": labReport,
        "discount": discount,
        "no_of_test": noOfTest,
        // "created_at": createdAt!.toIso8601String(),
        // "updated_at": updatedAt!.toIso8601String(),
        "paramater_data": List<dynamic>.from(paramaterData!.map((x) => x)),
      };
}

//TestDetail Model

TestDetailModel bookingDetailModelFromJson(String str) => TestDetailModel.fromJson(json.decode(str));

String bookingDetailModelToJson(TestDetailModel data) => json.encode(data.toJson());

class TestDetailModel {
  TestDetailModel({
    this.status,
    this.msg,
    this.data,
  });

  int? status;
  String? msg;
  Data? data;

  factory TestDetailModel.fromJson(Map<String, dynamic> json) => TestDetailModel(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data!.toJson(),
      };
}

class Data {
  Package package;
  List<Test> test;

  Data({
    required this.package,
    required this.test,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        package: Package.fromJson(json["package"]),
        test: List<Test>.from(json["test"].map((x) => Test.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "package": package.toJson(),
        "test": List<dynamic>.from(test.map((x) => x.toJson())),
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

class Package {
  int id;
  String branchId;
  String name;
  String shortDesc;
  int categoryId;
  String description;
  int mrp;
  int price;
  dynamic paramterIncluded;
  int sampleCollection;
  dynamic sampleCollectionFee;
  String? reportTime;
  int fastingTime;
  dynamic fastTime;
  String? testRecommendedFor;
  String? testRecommendedForAge;
  int realtedPackage;
  String labReport;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int noOfParameter;
  List<ParameterList> parameterList;
  List<Frqlist> frqlist;
  List<Review> review;
  double discount;
  int totalreview;
  double avgreview;

  Package({
    required this.id,
    required this.branchId,
    required this.name,
    required this.shortDesc,
    required this.categoryId,
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
    required this.realtedPackage,
    required this.labReport,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.noOfParameter,
    required this.parameterList,
    required this.frqlist,
    required this.review,
    required this.discount,
    required this.totalreview,
    required this.avgreview,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        branchId: json["branch_id"],
        name: json["name"],
        shortDesc: json["short_desc"],
        categoryId: json["category_id"],
        description: json["description"],
        mrp: json["mrp"],
        price: json["price"],
        paramterIncluded: json["paramter_included"],
        sampleCollection: json["sample_collection"] ?? null,
        sampleCollectionFee: json["sample_collection_fee"] ?? null,
        reportTime: json["report_time"]!,
        fastingTime: json["fasting_time"] ?? null,
        fastTime: json["fast_time"],
        testRecommendedFor: json["test_recommended_for"]!,
        testRecommendedForAge: json["test_recommended_for_age"]!,
        realtedPackage: json["realted_package"],
        labReport: json["lab_report"],
        deletedAt: json["deleted_at"] ?? null,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        noOfParameter: json["no_of_parameter"],
        parameterList: List<ParameterList>.from(json["parameter_list"].map((x) => ParameterList.fromJson(x))),
        frqlist: List<Frqlist>.from(json["frqlist"].map((x) => Frqlist.fromJson(x))),
        review: List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        discount: json["discount"]?.toDouble(),
        totalreview: json["totalreview"],
        avgreview: json["avgreview"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "name": name,
        "short_desc": shortDesc,
        "category_id": categoryId,
        "description": description,
        "mrp": mrp,
        "price": price,
        "paramter_included": paramterIncluded,
        "sample_collection": sampleCollection,
        "sample_collection_fee": sampleCollectionFee,
        "report_time": reportTimeValues.reverse[reportTime],
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for": testRecommendedForValues.reverse[testRecommendedFor],
        "test_recommended_for_age": testRecommendedForAgeValues.reverse[testRecommendedForAge],
        "realted_package": realtedPackage,
        "lab_report": labReport,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "no_of_parameter": noOfParameter,
        "parameter_list": List<dynamic>.from(parameterList.map((x) => x.toJson())),
        "frqlist": List<dynamic>.from(frqlist.map((x) => x.toJson())),
        "review": List<dynamic>.from(review.map((x) => x.toJson())),
        "discount": discount,
        "totalreview": totalreview,
        "avgreview": avgreview,
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

class ParameterList {
  String name;
  int id;
  int type;
  List<dynamic> parameter;

  ParameterList({
    required this.name,
    required this.id,
    required this.type,
    required this.parameter,
  });

  factory ParameterList.fromJson(Map<String, dynamic> json) => ParameterList(
        name: json["name"],
        id: json["id"],
        type: json["type"],
        parameter: List<dynamic>.from(json["parameter"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "type": type,
        "parameter": List<dynamic>.from(parameter.map((x) => x)),
      };
}

enum ReportTime { THE_72_HOURS, THE_24_HOURS }

final reportTimeValues = EnumValues({"24 Hours": ReportTime.THE_24_HOURS, "72 Hours": ReportTime.THE_72_HOURS});

class Review {
  int userId;
  int ratting;
  String date;
  String description;
  String username;
  String profilePic;

  Review({
    required this.userId,
    required this.ratting,
    required this.date,
    required this.description,
    required this.username,
    required this.profilePic,
  });

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

enum TestRecommendedFor { MALE_FEMALE }

final testRecommendedForValues = EnumValues({"Male,Female": TestRecommendedFor.MALE_FEMALE});

enum TestRecommendedForAge { THE_599_YEARS, N_A }

final testRecommendedForAgeValues = EnumValues({"N/A": TestRecommendedForAge.N_A, "5-99 Years": TestRecommendedForAge.THE_599_YEARS});

class Test {
  int id;
  String? profileName;
  int categoryId;
  dynamic branchId;
  String shortDesc;
  int mrp;
  int price;
  int sampleCollection;
  dynamic sampleCollectionFee;
  String? reportTime;
  int fastingTime;
  String? fastTime;
  String? testRecommendedFor;
  String? testRecommendedForAge;
  String description;
  String? noOfParameter;
  String labReport;
  dynamic deletedAt;
  // DateTime createdAt;
  // DateTime updatedAt;
  List<Test>? parameters;
  String? name;

  Test({
    required this.id,
    this.profileName,
    required this.categoryId,
    this.branchId,
    required this.shortDesc,
    required this.mrp,
    required this.price,
    required this.sampleCollection,
    this.sampleCollectionFee,
    required this.reportTime,
    required this.fastingTime,
    this.fastTime,
    required this.testRecommendedFor,
    required this.testRecommendedForAge,
    required this.description,
    this.noOfParameter,
    required this.labReport,
    this.deletedAt,
    // required this.createdAt,
    // required this.updatedAt,
    this.parameters,
    this.name,
  });

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        id: json["id"],
        profileName: json["profile_name"],
        categoryId: json["category_id"],
        branchId: json["branch_id"],
        shortDesc: json["short_desc"],
        mrp: json["mrp"],
        price: json["price"],
        sampleCollection: json["sample_collection"],
        sampleCollectionFee: json["sample_collection_fee"],
        reportTime: json["report_time"]!,
        fastingTime: json["fasting_time"],
        fastTime: json["fast_time"],
        testRecommendedFor: json["test_recommended_for"]!,
        testRecommendedForAge: json["test_recommended_for_age"]!,
        description: json["description"],
        noOfParameter: json["no_of_parameter"],
        labReport: json["lab_report"] ?? '',
        deletedAt: json["deleted_at"],
        // createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        // createdAt: json['birthdate'] != null ? DateTime.parse(json['birthdate'].toString()).toLocal() : null;
        // updatedAt: DateTime.parse(json["updated_at"]),
        parameters: json["parameters"] == null ? [] : List<Test>.from(json["parameters"]!.map((x) => Test.fromJson(x))),
        name: json["name"],
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
        "report_time": reportTimeValues.reverse[reportTime],
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for": testRecommendedForValues.reverse[testRecommendedFor],
        "test_recommended_for_age": testRecommendedForAgeValues.reverse[testRecommendedForAge],
        "description": description,
        "no_of_parameter": noOfParameter,
        "lab_report": labReport,
        "deleted_at": deletedAt,
        // "created_at": createdAt.toIso8601String(),
        // "updated_at": updatedAt.toIso8601String(),
        "parameters": parameters == null ? [] : List<dynamic>.from(parameters!.map((x) => x.toJson())),
        "name": name,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
