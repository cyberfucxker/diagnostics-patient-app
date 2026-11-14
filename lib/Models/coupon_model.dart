import 'dart:convert';

CouponModel couponListModelFromJson(String str) => CouponModel.fromJson(json.decode(str));

String couponListModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  int status;
  String msg;
  List<CouponListModel> data;

  CouponModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        status: json["status"],
        msg: json["msg"],
        data: List<CouponListModel>.from(json["data"].map((x) => CouponListModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CouponListModel {
  int? id;
  String? couponCode;
  int? type;
  String? productIds;
  String? day;
  String? couponType;
  int? couponValue;
  DateTime? couponStartDate;
  DateTime? couponEndDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? dayList;

  CouponListModel({this.id, this.couponCode, this.type, this.productIds, this.couponType, this.couponValue, this.day, this.couponStartDate, this.couponEndDate, this.createdAt, this.updatedAt, this.dayList});

  CouponListModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      couponCode = json["coupon_code"];
      type = json["type"];

      couponType = json["coupon_type"];
      day = json["day"];
      couponValue = json["coupon_value"] != null ? int.parse(json["coupon_value"].toString()) : 0;
      couponStartDate = DateTime.parse(json["coupon_start_date"]);
      couponEndDate = DateTime.parse(json["coupon_end_date"]);
      createdAt = DateTime.parse(json["created_at"]);
      updatedAt = DateTime.parse(json["updated_at"]);
      productIds = json["product_ids"] != null ? json["product_ids"].toString() : '';
    } catch (e) {
      print('Exception : coupon_model.dart - CouponListModel.fromJson()' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_code": couponCode,
        "type": type,
        "day": day,
        "product_ids": productIds,
        "coupon_type": couponType,
        "coupon_value": couponValue,
        "coupon_start_date": "${couponStartDate!.year.toString().padLeft(4, '0')}-${couponStartDate!.month.toString().padLeft(2, '0')}-${couponStartDate!.day.toString().padLeft(2, '0')}",
        "coupon_end_date": "${couponEndDate!.year.toString().padLeft(4, '0')}-${couponEndDate!.month.toString().padLeft(2, '0')}-${couponEndDate!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
