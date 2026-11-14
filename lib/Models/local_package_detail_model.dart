// To parse this JSON data, do
//
//     final localPackageModel = localPackageModelFromJson(jsonString);

import 'dart:convert';

LocalPackageModel localPackageModelFromJson(String str) => LocalPackageModel.fromJson(json.decode(str));

String localPackageModelToJson(LocalPackageModel data) => json.encode(data.toJson());

class LocalPackageModel {
  LocalPackageModel({
    this.id,
    this.userId,
    this.packageId,
    this.packageType,
    this.packageName,
    this.packageMrp,
    this.packagePrice,
    this.packageParameters,
    this.packageDiscount,
  });

  int? id;
  int? userId;
  int? packageId;
  int? packageType;
  String? packageName;
  int? packageMrp;
  int? packagePrice;
  String? packageParameters;
  String? packageDiscount;

  factory LocalPackageModel.fromJson(Map<String, dynamic> json) => LocalPackageModel(
        id: json["id"],
        userId: json["packageMemberId"],
        packageId: json["packageId"],
        packageType: json["packageType"],
        packageName: json["packageName"],
        packageMrp: json["packageMrp"],
        packagePrice: json["packagePrice"],
        packageParameters: json["packageParameters"],
        packageDiscount: json["packageDiscount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "packageMemberId": userId,
        "packageId": packageId,
        "packageType": packageType,
        "packageName": packageName,
        "packageMrp": packageMrp,
        "packagePrice": packagePrice,
        "packageParameters": packageParameters,
        "packageDiscount": packageDiscount,
      };
}
