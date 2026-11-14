// To parse this JSON data, do
//
//     final bookingDetailModel = bookingDetailModelFromJson(jsonString);

import 'dart:convert';

BookingDetailModel bookingDetailModelFromJson(String str) => BookingDetailModel.fromJson(json.decode(str));

String bookingDetailModelToJson(BookingDetailModel data) => json.encode(data.toJson());

class BookingDetailModel {
  int? status;
  String? msg;
  Data data = Data(partiallyreports: []);

  BookingDetailModel({
    this.status,
    this.msg,
    required this.data,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) => BookingDetailModel(
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
    this.id,
    this.userId,
    this.managerId,
    this.feedback,
    this.sampleCollectionAddressId,
    this.date,
    this.time,
    this.paymentMethod,
    this.token,
    this.subtotal,
    this.tax,
    this.finalTotal,
    this.status,
    this.orderplaceDate,
    this.acceptDatetime,
    this.rejectDatetime,
    this.rejectDescription,
    this.refundDatetime,
    this.collectedDatetime,
    this.completeDatetime,
    this.report,
    this.createdAt,
    this.cashbackPoint,
    this.couponDiscount,
    this.walletDiscount,
    this.couponId,
    this.isCompleted,
    this.updatedAt,
    this.phone,
    this.orderdata,
    this.discount,
    this.useraddressdetails,
    required this.partiallyreports,
    this.sampleboyDetails,
  });

  int? id;
  int? userId;
  dynamic managerId;
  int? feedback;
  int? sampleCollectionAddressId;
  DateTime? date;
  String? time;
  String? paymentMethod;
  String? token;
  double? subtotal;
  double? tax;
  double? finalTotal;
  int? status;
  dynamic couponId;
  dynamic couponDiscount;
  dynamic cashbackPoint;
  double? walletDiscount;
  String? orderplaceDate;
  dynamic acceptDatetime;
  dynamic rejectDatetime;
  dynamic rejectDescription;
  dynamic refundDatetime;
  dynamic collectedDatetime;
  dynamic completeDatetime;
  dynamic report;
  int? isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? phone;
  Discount? discount;
  List<Orderdatum>? orderdata;
  Useraddressdetails? useraddressdetails;
  List<Partiallyreport> partiallyreports = [];
  SampleboyDetails? sampleboyDetails;

  Data.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      userId = json["user_id"];
      managerId = json["manager_id"];
      feedback = json["feedback"];
      sampleCollectionAddressId = json["sample_collection_address_id"];
      date = DateTime.parse(json["date"]);
      time = json["time"];
      paymentMethod = json["payment_method"];
      token = json["token"] != null ? json["token"].toString() : '';
      subtotal = double.parse(json["subtotal"].toString());
      tax = json["tax"] != null ? double.parse(json["tax"].toString()) : 0.0;
      finalTotal = double.parse(json["final_total"].toString());
      status = json["status"];
      // status: 7,
      orderplaceDate = json["orderplace_date"];
      acceptDatetime = json["accept_datetime"];
      rejectDatetime = json["reject_datetime"];
      rejectDescription = json["reject_description"];
      refundDatetime = json["refund_datetime"];
      collectedDatetime = json["collected_datetime"];
      completeDatetime = json["complete_datetime"];
      report = json["report"];
      couponId = json["coupon_id"];
      couponDiscount = json["coupon_discount"];
      cashbackPoint = json["cashback_point"];
      walletDiscount = double.parse(json["wallet_discount"].toString());
      isCompleted = json["is_completed"];
      createdAt = DateTime.parse(json["created_at"]);
      updatedAt = DateTime.parse(json["updated_at"]);
      phone = json["phone"];
      discount = Discount.fromJson(json["discount"]);
      orderdata = List<Orderdatum>.from(json["orderdata"].map((x) => Orderdatum.fromJson(x)));
      useraddressdetails = json["useraddressdetails"] == null ? null : Useraddressdetails.fromJson(json["useraddressdetails"]);
      partiallyreports = List<Partiallyreport>.from(json["partiallyreports"].map((x) => Partiallyreport.fromJson(x)));
      // sampleboyDetails: SampleboyDetails.fromJson(json["sampleboy_details"]),
      sampleboyDetails = json["sampleboy_details"] == null ? null : SampleboyDetails.fromJson(json["sampleboy_details"]);
    } catch (e) {
      print('booking detail modelcddc :' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "manager_id": managerId,
        "feedback": feedback,
        "sample_collection_address_id": sampleCollectionAddressId,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "payment_method": paymentMethod,
        "token": token,
        "subtotal": subtotal,
        "tax": tax,
        "final_total": finalTotal,
        "is_completed": isCompleted,
        "coupon_id": couponId,
        "coupon_discount": couponDiscount,
        "cashback_point": cashbackPoint,
        "wallet_discount": walletDiscount,
        "status": status,
        "orderplace_date": orderplaceDate,
        "accept_datetime": acceptDatetime,
        "reject_datetime": rejectDatetime,
        "reject_description": rejectDescription,
        "refund_datetime": refundDatetime,
        "collected_datetime": collectedDatetime,
        "complete_datetime": completeDatetime,
        "report": report,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "phone": phone,
        "discount": discount,
        "orderdata": List<dynamic>.from(orderdata!.map((x) => x.toJson())),
        "useraddressdetails": useraddressdetails!.toJson(),
        "partiallyreports": List<dynamic>.from(partiallyreports.map((x) => x.toJson())),
        "sampleboy_details": sampleboyDetails!.toJson(),
      };
}

class SampleboyDetails {
  int id;
  String name;
  int phone;
  dynamic profilePic;
  String email;
  dynamic dOB;
  dynamic age;
  dynamic sex;
  int userType;
  int city;
  dynamic branchCode;
  int sampleBranch;
  String address;
  dynamic companyName;
  String description;
  int walletAmount;
  dynamic emailVerifiedAt;
  dynamic otp;
  int orderNotification;
  int loginType;
  dynamic soicalId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  SampleboyDetails({
    required this.id,
    required this.name,
    required this.phone,
    required this.profilePic,
    required this.email,
    required this.dOB,
    required this.age,
    required this.sex,
    required this.userType,
    required this.city,
    required this.branchCode,
    required this.sampleBranch,
    required this.address,
    required this.companyName,
    required this.description,
    required this.walletAmount,
    required this.emailVerifiedAt,
    required this.otp,
    required this.orderNotification,
    required this.loginType,
    required this.soicalId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory SampleboyDetails.fromJson(Map<String, dynamic> json) => SampleboyDetails(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        profilePic: json["profile_pic"],
        email: json["email"],
        dOB: json["d_o_b"],
        age: json["age"],
        sex: json["sex"],
        userType: json["user_type"],
        city: json["city"],
        branchCode: json["branch_code"],
        sampleBranch: json["sample_branch"],
        address: json["address"],
        companyName: json["company_name"],
        description: json["description"] != null ? json["description"].toString() : '',
        walletAmount: json["wallet_amount"],
        emailVerifiedAt: json["email_verified_at"],
        otp: json["otp"],
        orderNotification: json["order_notification"],
        loginType: json["login_type"],
        soicalId: json["soical_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

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
        "sample_branch": sampleBranch,
        "address": address,
        "company_name": companyName,
        "description": description,
        "wallet_amount": walletAmount,
        "email_verified_at": emailVerifiedAt,
        "otp": otp,
        "order_notification": orderNotification,
        "login_type": loginType,
        "soical_id": soicalId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Orderdatum {
  Orderdatum({
    this.memberId,
    this.memberName,
    this.relation,
    this.gender,
    this.age,
    this.testdata,
  });

  int? memberId;
  String? memberName;
  String? relation;
  String? gender;
  int? age;
  List<Testdatum>? testdata;

  factory Orderdatum.fromJson(Map<String, dynamic> json) => Orderdatum(
        memberId: json["member_id"],
        memberName: json["member_name"],
        relation: json["relation"],
        gender: json["gender"],
        age: json["age"],
        testdata: List<Testdatum>.from(json["testdata"].map((x) => Testdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "member_name": memberName,
        "relation": relation,
        "gender": gender,
        "age": age,
        "testdata": List<dynamic>.from(testdata!.map((x) => x.toJson())),
      };
}

class Testdatum {
  Testdatum({
    this.testName,
    this.mrp,
    this.price,
    this.parameter,
    this.type,
    this.typeId,
    required this.discount,
  });

  String? testName;
  int? mrp;
  int? price;
  int? parameter;
  int? type;
  int? typeId;
  Discount discount;

  factory Testdatum.fromJson(Map<String, dynamic> json) => Testdatum(
        testName: json["test_name"],
        mrp: json["mrp"],
        price: json["price"] != null ? json["price"].toInt() : 0,
        parameter: json["parameter"],
        type: json["type"],
        typeId: json["type_id"],
        discount: Discount.fromJson(json["discount"]),
      );

  Map<String, dynamic> toJson() => {
        "test_name": testName,
        "mrp": mrp,
        "price": price,
        "parameter": parameter,
        "type": type,
        "type_id": typeId,
        "discount": discount,
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

class Useraddressdetails {
  Useraddressdetails({
    this.id,
    this.userId,
    this.name,
    this.houseNo,
    this.pincode,
    this.city,
    this.state,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.address,
    this.lat,
    this.long,
    this.phone,
  });

  int? id;
  int? userId;
  String? name;
  dynamic houseNo;
  int? pincode;
  dynamic city;
  String? state;
  int? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? address;
  double? lat;
  double? long;
  int? phone;

  factory Useraddressdetails.fromJson(Map<String, dynamic> json) => Useraddressdetails(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        houseNo: json["house_no"],
        pincode: json["pincode"],
        city: json["city"],
        state: json["state"],
        isDefault: json["is_default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        address: json["address"],
        lat: json["lat"].toDouble(),
        long: json["long"].toDouble(),
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "house_no": houseNo,
        "pincode": pincode,
        "city": city,
        "state": state,
        "is_default": isDefault,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "address": address,
        "lat": lat,
        "long": long,
        "phone": phone,
      };
}

class Partiallyreport {
  int id;
  int orderId;
  int testRegId;
  String reportName;
  String report;
  DateTime createdAt;
  DateTime updatedAt;

  Partiallyreport({
    required this.id,
    required this.orderId,
    required this.testRegId,
    required this.reportName,
    required this.report,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Partiallyreport.fromJson(Map<String, dynamic> json) => Partiallyreport(
        id: json["id"],
        orderId: json["order_id"] ?? 0,
        testRegId: json["test_reg_id"] ?? 0,
        reportName: json["report_name"] ?? '',
        report: json["report"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "test_reg_id": testRegId,
        "report_name": reportName,
        "report": report,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
