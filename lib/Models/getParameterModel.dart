class GetParameterModel {
  int status;
  String msg;
  List<GetParameterListModel> data;

  GetParameterModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory GetParameterModel.fromJson(Map<String, dynamic> json) =>
      GetParameterModel(
        status: json["status"] ?? 0,
        msg: json["msg"] ?? "",
        data: json["data"] == null
            ? []
            : List<GetParameterListModel>.from(
                json["data"].map((x) => GetParameterListModel.fromJson(x))),
      );
}

class GetParameterListModel {
  int id;
  String name;
  String testMethod;
  String testShortCode;
  dynamic categoryId;
  String branchId;
  String? shortDesc;
  String? description;
  int mrp;
  double price;
  int sampleCollection;
  dynamic sampleCollectionFee;
  ReportAvailability reportAvailability;
  ReportTime reportTime;
  int fastingTime;
  dynamic fastTime;
  TestRecommendedFor testRecommendedFor;
  TestRecommendedForAge testRecommendedForAge;
  dynamic labReport;
  dynamic deletedAt;
  dynamic createdAt;
  DateTime? updatedAt;

  GetParameterListModel({
    required this.id,
    required this.name,
    required this.testMethod,
    required this.testShortCode,
    required this.categoryId,
    required this.branchId,
    required this.shortDesc,
    required this.description,
    required this.mrp,
    required this.price,
    required this.sampleCollection,
    required this.sampleCollectionFee,
    required this.reportAvailability,
    required this.reportTime,
    required this.fastingTime,
    required this.fastTime,
    required this.testRecommendedFor,
    required this.testRecommendedForAge,
    required this.labReport,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetParameterListModel.fromJson(Map<String, dynamic> json) =>
      GetParameterListModel(
        id: json["id"],
        name: json["name"],
        testMethod: json["test_method"],
        testShortCode: json["test_short_code"],
        categoryId: json["category_id"],
        branchId: json["branch_id"],
        shortDesc: json["short_desc"],
        description: json["description"],
        mrp: json["mrp"],
        price: json["price"]?.toDouble(),
        sampleCollection: json["sample_collection"],
        sampleCollectionFee: json["sample_collection_fee"],
        reportAvailability:
            reportAvailabilityValues.map[json["report_availability"]]!,
        reportTime: reportTimeValues.map[json["report_time"]]!,
        fastingTime: json["fasting_time"],
        fastTime: json["fast_time"],
        testRecommendedFor:
            testRecommendedForValues.map[json["test_recommended_for"]]!,
        testRecommendedForAge:
            testRecommendedForAgeValues.map[json["test_recommended_for_age"]]!,
        labReport: json["lab_report"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "test_method": testMethod,
        "test_short_code": testShortCode,
        "category_id": categoryId,
        "branch_id": branchId,
        "short_desc": shortDesc,
        "description": description,
        "mrp": mrp,
        "price": price,
        "sample_collection": sampleCollection,
        "sample_collection_fee": sampleCollectionFee,
        "report_availability":
            reportAvailabilityValues.reverse[reportAvailability],
        "report_time": reportTimeValues.reverse[reportTime],
        "fasting_time": fastingTime,
        "fast_time": fastTime,
        "test_recommended_for":
            testRecommendedForValues.reverse[testRecommendedFor],
        "test_recommended_for_age":
            testRecommendedForAgeValues.reverse[testRecommendedForAge],
        "lab_report": labReport,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

enum ReportAvailability {
  EMPTY,
  IN_10_DAYS,
  IN_15_DAYS,
  IN_20_DAYS,
  IN_3_DAYS,
  IN_5_DAYS,
  IN_6_WEEKS,
  NEXT_DAY,
  NEXT_DAYS,
  REPORT_AVAILABILITY_IN_15_DAYS,
  REPORT_AVAILABILITY_IN_5_DAYS,
  REPORT_AVAILABILITY_SAME_DAY,
  SAME_DAY,
  UP_TO_36_TO_72_HRS
}

final reportAvailabilityValues = EnumValues({
  "": ReportAvailability.EMPTY,
  "In 10 Days": ReportAvailability.IN_10_DAYS,
  "IN 15 DAYS": ReportAvailability.IN_15_DAYS,
  "In 20 Days": ReportAvailability.IN_20_DAYS,
  "In 3 Days": ReportAvailability.IN_3_DAYS,
  "In 5 Days": ReportAvailability.IN_5_DAYS,
  "In 6 Weeks": ReportAvailability.IN_6_WEEKS,
  "Next Day": ReportAvailability.NEXT_DAY,
  "Next Days": ReportAvailability.NEXT_DAYS,
  "In 15 Days": ReportAvailability.REPORT_AVAILABILITY_IN_15_DAYS,
  "IN 5 DAYS": ReportAvailability.REPORT_AVAILABILITY_IN_5_DAYS,
  "same Day": ReportAvailability.REPORT_AVAILABILITY_SAME_DAY,
  "Same Day": ReportAvailability.SAME_DAY,
  "Up to 36 to 72 Hrs": ReportAvailability.UP_TO_36_TO_72_HRS
});

enum ReportTime { THE_24_HOURS }

final reportTimeValues = EnumValues({"24 Hours": ReportTime.THE_24_HOURS});

enum TestRecommendedFor { FEMALE, MALE_FEMALE, RE }

final testRecommendedForValues = EnumValues({
  "Female": TestRecommendedFor.FEMALE,
  "Male, Female": TestRecommendedFor.MALE_FEMALE,
  "re": TestRecommendedFor.RE
});

enum TestRecommendedForAge { THE_599_YEARS }

final testRecommendedForAgeValues =
    EnumValues({"5-99 Years": TestRecommendedForAge.THE_599_YEARS});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
