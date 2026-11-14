// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

BookListModel bookListModelFromJson(String str) =>
    BookListModel.fromJson(json.decode(str));

String bookListModelToJson(BookListModel data) => json.encode(data.toJson());

// ─────────────────────────────────────────────────────────────────────────────
class BookListModel {
  final int?    status;
  final String? msg;
  final Data?   data;

  BookListModel({this.status, this.msg, this.data});

  factory BookListModel.fromJson(Map<String, dynamic> json) => BookListModel(
    status: json["status"],
    msg:    json["msg"],
    data:   json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg":    msg,
    "data":   data?.toJson(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
class Data {
  final int?         currentPage;
  final List<OrderData>? data;
  final String?      firstPageUrl;
  final int?         from;
  final int?         lastPage;
  final String?      lastPageUrl;
  final List<Link>?  links;
  final String?      nextPageUrl;
  final String?      path;
  final int?         perPage;
  final dynamic      prevPageUrl;
  final int?         to;
  final int?         total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage:  json["current_page"],
    data: json["data"] == null
        ? []
        : List<OrderData>.from(
        (json["data"] as List).map((x) => OrderData.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from:         json["from"],
    lastPage:     json["last_page"],
    lastPageUrl:  json["last_page_url"],
    links: json["links"] == null
        ? []
        : List<Link>.from(
        (json["links"] as List).map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path:        json["path"],
    perPage:     json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to:          json["to"],
    total:       json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page":   currentPage,
    "data":           data?.map((x) => x.toJson()).toList() ?? [],
    "first_page_url": firstPageUrl,
    "from":           from,
    "last_page":      lastPage,
    "last_page_url":  lastPageUrl,
    "links":          links?.map((x) => x.toJson()).toList() ?? [],
    "next_page_url":  nextPageUrl,
    "path":           path,
    "per_page":       perPage,
    "prev_page_url":  prevPageUrl,
    "to":             to,
    "total":          total,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
class OrderData {
  final int?               id;
  final String?            paymentMethod;
  final DateTime?          date;       // ← nullable — backend null bhej sakta hai
  final String?            time;       // ← nullable
  final double?            finalTotal; // ← nullable — null.toDouble() fix
  final int?               status;
  final SampleboyDetails?  sampleboyDetails;

  OrderData({
    this.id,
    this.paymentMethod,
    this.date,
    this.time,
    this.finalTotal,
    this.status,
    this.sampleboyDetails,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    id:            json["id"],
    paymentMethod: json["payment_method"]?.toString(),

    // ✅ FIX 1: DateTime.parse(null) crash — safe parse
    date: _parseDate(json["date"]),

    time:       json["time"]?.toString(),

    // ✅ FIX 2: null.toDouble() crash — null-safe
    finalTotal: _parseDouble(json["final_total"]),

    status: json["status"],
    sampleboyDetails: json["sampleboy_details"] == null
        ? null
        : SampleboyDetails.fromJson(
        json["sampleboy_details"] as Map<String, dynamic>),
  );

  // ── Helpers ──────────────────────────────────────────────────────────────
  static DateTime? _parseDate(dynamic val) {
    if (val == null || val.toString().trim().isEmpty) return null;
    try {
      return DateTime.parse(val.toString());
    } catch (_) {
      return null;
    }
  }

  static double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is double) return val;
    if (val is int)    return val.toDouble();
    return double.tryParse(val.toString());
  }

  Map<String, dynamic> toJson() => {
    "id":            id,
    "payment_method": paymentMethod,
    "date": date == null
        ? null
        : "${date!.year.toString().padLeft(4, '0')}-"
        "${date!.month.toString().padLeft(2, '0')}-"
        "${date!.day.toString().padLeft(2, '0')}",
    "time":            time,
    "final_total":     finalTotal,
    "status":          status,
    "sampleboy_details": sampleboyDetails?.toJson(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
class SampleboyDetails {
  final int     id;
  final String  name;
  final int     phone;
  final dynamic profilePic;
  final String  email;
  final dynamic dOB;
  final dynamic age;
  final dynamic sex;
  final int     userType;
  final int     city;
  final dynamic branchCode;
  final int     sampleBranch;
  final String  address;
  final dynamic companyName;
  final String  description;
  final int     walletAmount;
  final dynamic emailVerifiedAt;
  final dynamic otp;
  final int     orderNotification;
  final int     loginType;
  final dynamic soicalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

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

  factory SampleboyDetails.fromJson(Map<String, dynamic> json) =>
      SampleboyDetails(
        id:           json["id"]           ?? 0,
        name:         json["name"]?.toString()    ?? '',
        phone:        json["phone"]        ?? 0,
        profilePic:   json["profile_pic"],
        email:        json["email"]?.toString()   ?? '',
        dOB:          json["d_o_b"],
        age:          json["age"],
        sex:          json["sex"],
        userType:     json["user_type"]    ?? 0,
        city:         json["city"]         ?? 0,
        branchCode:   json["branch_code"],
        sampleBranch: json["sample_branch"] ?? 0,
        address:      json["address"]?.toString() ?? '',
        companyName:  json["company_name"],
        description:  json["description"]?.toString() ?? '',
        walletAmount: json["wallet_amount"] ?? 0,
        emailVerifiedAt: json["email_verified_at"],
        otp:          json["otp"],
        orderNotification: json["order_notification"] ?? 0,
        loginType:    json["login_type"]   ?? 0,
        soicalId:     json["soical_id"],
        createdAt: _safeParse(json["created_at"]),
        updatedAt: _safeParse(json["updated_at"]),
        deletedAt:    json["deleted_at"],
      );

  static DateTime _safeParse(dynamic val) {
    if (val == null) return DateTime.now();
    try { return DateTime.parse(val.toString()); } catch (_) { return DateTime.now(); }
  }

  Map<String, dynamic> toJson() => {
    "id":                 id,
    "name":               name,
    "phone":              phone,
    "profile_pic":        profilePic,
    "email":              email,
    "d_o_b":              dOB,
    "age":                age,
    "sex":                sex,
    "user_type":          userType,
    "city":               city,
    "branch_code":        branchCode,
    "sample_branch":      sampleBranch,
    "address":            address,
    "company_name":       companyName,
    "description":        description,
    "wallet_amount":      walletAmount,
    "email_verified_at":  emailVerifiedAt,
    "otp":                otp,
    "order_notification": orderNotification,
    "login_type":         loginType,
    "soical_id":          soicalId,
    "created_at":         createdAt.toIso8601String(),
    "updated_at":         updatedAt.toIso8601String(),
    "deleted_at":         deletedAt,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
class Link {
  final String?  url;
  final dynamic  label;
  final bool?    active;

  Link({this.url, this.label, this.active});

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url:    json["url"],
    label:  json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url":    url,
    "label":  label,
    "active": active,
  };
}