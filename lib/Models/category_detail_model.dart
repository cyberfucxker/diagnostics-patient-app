// // To parse this JSON data, do
// //
// //     final categoryDetailModel = categoryDetailModelFromJson(jsonString);

// import 'dart:convert';

// CategoryDetailModel categoryDetailModelFromJson(String str) => CategoryDetailModel.fromJson(json.decode(str));

// String categoryDetailModelToJson(CategoryDetailModel data) => json.encode(data.toJson());

// class CategoryDetailModel {
//   CategoryDetailModel({
//     this.status,
//     this.msg,
//     this.data,
//   });

//   int? status;
//   String? msg;
//   Data? data;

//   factory CategoryDetailModel.fromJson(Map<String, dynamic> json) => CategoryDetailModel(
//         status: json["status"],
//         msg: json["msg"],
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "msg": msg,
//         "data": data!.toJson(),
//       };
// }

// class Data {
//   Data({
//     this.id,
//     this.name,
//     this.image,
//     this.description,
//     this.shortDesc,
//     this.isDeleted,
//     this.createdAt,
//     this.updatedAt,
//     this.packageDetail,
//     this.currency,
//   });

//   int? id;
//   String? name;
//   String? image;
//   String? description;
//   String? shortDesc;
//   int? isDeleted;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   PackageDetail? packageDetail;
//   String? currency;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         name: json["name"] != null ? json["name"] : '',
//         image: json["image"] != null ? json["image"] : '',
//         description: json["description"] != null ? json["description"] : '',
//         shortDesc: json["short_desc"],
//         isDeleted: json["is_deleted"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         packageDetail: PackageDetail.fromJson(json["package_detail"]),
//         currency: json["currency"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "description": description,
//         "short_desc": shortDesc,
//         "is_deleted": isDeleted,
//         "created_at": createdAt!.toIso8601String(),
//         "updated_at": updatedAt!.toIso8601String(),
//         "package_detail": packageDetail!.toJson(),
//         "currency": currency,
//       };
// }

// class PackageDetail {
//   PackageDetail({
//     this.currentPage,
//     this.data,
//     this.firstPageUrl,
//     this.from,
//     this.lastPage,
//     this.lastPageUrl,
//     this.links,
//     this.nextPageUrl,
//     this.path,
//     this.perPage,
//     this.prevPageUrl,
//     this.to,
//     this.total,
//   });

//   int? currentPage;
//   List<PackageDetailDate>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Link>? links;
//   dynamic nextPageUrl;
//   String? path;
//   int? perPage;
//   dynamic prevPageUrl;
//   int? to;
//   int? total;

//   factory PackageDetail.fromJson(Map<String, dynamic> json) => PackageDetail(
//         currentPage: json["current_page"],
//         data: List<PackageDetailDate>.from(json["data"].map((x) => PackageDetailDate.fromJson(x))),
//         firstPageUrl: json["first_page_url"],
//         from: json["from"],
//         lastPage: json["last_page"],
//         lastPageUrl: json["last_page_url"],
//         links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
//         nextPageUrl: json["next_page_url"],
//         path: json["path"],
//         perPage: json["per_page"],
//         prevPageUrl: json["prev_page_url"],
//         to: json["to"],
//         total: json["total"],
//       );

//   Map<String, dynamic> toJson() => {
//         "current_page": currentPage,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//         "first_page_url": firstPageUrl,
//         "from": from,
//         "last_page": lastPage,
//         "last_page_url": lastPageUrl,
//         "links": List<dynamic>.from(links!.map((x) => x.toJson())),
//         "next_page_url": nextPageUrl,
//         "path": path,
//         "per_page": perPage,
//         "prev_page_url": prevPageUrl,
//         "to": to,
//         "total": total,
//       };
// }

// class PackageDetailDate {
//   PackageDetailDate({
//     this.id,
//     this.name,
//     this.mrp,
//     this.price,
//     this.discount,
//     this.type,
//     this.noOfParameter,
//     this.parameterList,
//   });

//   int? id;
//   String? name;
//   int? mrp;
//   double? price;
//   double? discount;
//   int? type;
//   int? noOfParameter;
//   List<String>? parameterList;

//   factory PackageDetailDate.fromJson(Map<String, dynamic> json) => PackageDetailDate(
//         id: json["id"],
//         name: json["name"],
//         mrp: json["mrp"],
//         price: json["price"] != null ? double.parse(json["price"].toString()) : 0.0,
//         discount: json["discount"].toDouble(),
//         type: json["type"],
//         noOfParameter: json["no_of_parameter"],
//         parameterList: List<String>.from(json["parameter_list"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "mrp": mrp,
//         "price": price,
//         "discount": discount,
//         "type": type,
//         "no_of_parameter": noOfParameter,
//         "parameter_list": List<dynamic>.from(parameterList!.map((x) => x)),
//       };
// }

// class Link {
//   Link({
//     this.url,
//     this.label,
//     this.active,
//   });

//   String? url;
//   dynamic label;
//   bool? active;

//   factory Link.fromJson(Map<String, dynamic> json) => Link(
//         url: json["url"] == null ? null : json["url"],
//         label: json["label"],
//         active: json["active"],
//       );

//   Map<String, dynamic> toJson() => {
//         "url": url == null ? null : url,
//         "label": label,
//         "active": active,
//       };
// }

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CategoryDetailModel welcomeFromJson(String str) => CategoryDetailModel.fromJson(json.decode(str));

String welcomeToJson(CategoryDetailModel data) => json.encode(data.toJson());

class CategoryDetailModel {
  int? status;
  String? msg;
  Data? data;

  CategoryDetailModel({
    this.status,
    this.msg,
    this.data,
  });

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) => CategoryDetailModel(
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
  int? id;
  String? name;
  String? image;
  String? description;
  String? shortDesc;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<PackageDetail>? packageDetail;
  String? currency;

  Data({
    this.id,
    this.name,
    this.image,
    this.description,
    this.shortDesc,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.packageDetail,
    this.currency,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        shortDesc: json["short_desc"],
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        packageDetail: List<PackageDetail>.from(json["package_detail"].map((x) => PackageDetail.fromJson(x))),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "short_desc": shortDesc,
        "is_deleted": isDeleted,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "package_detail": List<dynamic>.from(packageDetail!.map((x) => x.toJson())),
        "currency": currency,
      };
}

class PackageDetail {
  int? id;
  String? name;
  int? mrp;
  double? price;
  // int? discount;
  int? type;
  int? noOfParameter;
  Discount discount;
  List<String>? parameterList;

  PackageDetail({
    this.id,
    this.name,
    this.mrp,
    this.price,
    // this.discount,
    this.type,
    this.noOfParameter,
    required this.discount,
    this.parameterList,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) => PackageDetail(
        id: json["id"],
        name: json["name"],
        mrp: json["mrp"],
        price: json["price"]?.toDouble(),
        // discount: json["discount"],
        type: json["type"],
        noOfParameter: json["no_of_parameter"],
        discount: Discount.fromJson(json["discount"]),
        parameterList: List<String>.from(json["parameter_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mrp": mrp,
        "price": price,
        "discount": discount,
        "type": type,
        "no_of_parameter": noOfParameter,
        "parameter_list": List<dynamic>.from(parameterList!.map((x) => x)),
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
