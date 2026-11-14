import 'dart:convert';

AddressListModel addressListModelFromJson(String str) =>
    AddressListModel.fromJson(json.decode(str));

String addressListModelToJson(AddressListModel data) =>
    json.encode(data.toJson());

class AddressListModel {
  AddressListModel({this.status, this.msg, this.data});

  int? status;
  String? msg;
  List<AddressModel>? data;

  factory AddressListModel.fromJson(Map<String, dynamic> json) =>
      AddressListModel(
        status: json["status"],
        msg: json["msg"],
        data: List<AddressModel>.from(
            json["data"].map((x) => AddressModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AddressModel {
  AddressModel({
    this.id,
    this.userId,
    this.name,
    this.houseNo,
    this.pincode,
    this.city,
    this.state,
    this.phone,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.address,
    this.lat,
    this.long,
    this.apartment, // ✅ ADDED
    this.landmark,  // ✅ ADDED
  });

  int? id;
  int? userId;
  String? name;
  String? houseNo;
  String? pincode;
  String? city;
  String? state;
  int? phone;
  int? isDefault;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? address;
  double? lat;
  double? long;
  String? apartment; // ✅ ADDED
  String? landmark;  // ✅ ADDED

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id:        json["id"],
    userId:    json["user_id"],
    name:      json["name"]?.toString(),
    houseNo:   json["house_no"]?.toString(),
    pincode:   json["pincode"]?.toString(),
    city:      json["city"]?.toString(),
    state:     json["state"]?.toString(),
    phone:     json["phone"],
    isDefault: json["is_default"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    deletedAt: json["deleted_at"],
    address:   json["address"],
    lat:       json["lat"] != null
        ? double.tryParse(json["lat"].toString())
        : null,
    long:      json["long"] != null
        ? double.tryParse(json["long"].toString())
        : null,
    apartment: json["apartment"]?.toString(), // ✅ ADDED
    landmark:  json["landmark"]?.toString(),  // ✅ ADDED
  );

  Map<String, dynamic> toJson() => {
    "id":         id,
    "user_id":    userId,
    "name":       name,
    "house_no":   houseNo,
    "pincode":    pincode,
    "city":       city,
    "state":      state,
    "phone":      phone,
    "is_default": isDefault,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "deleted_at": deletedAt,
    "address":    address,
    "lat":        lat,
    "long":       long,
    "apartment":  apartment, // ✅ ADDED
    "landmark":   landmark,  // ✅ ADDED
  };
}

ManageCityModel welcomeFromJson(String str) =>
    ManageCityModel.fromJson(json.decode(str));

String welcomeToJson(ManageCityModel data) => json.encode(data.toJson());

class ManageCityModel {
  int? status;
  String? msg;
  List<CityList>? data;

  ManageCityModel({
    this.status,
    this.msg,
    this.data,
  });

  factory ManageCityModel.fromJson(Map<String, dynamic> json) =>
      ManageCityModel(
        status: json["status"],
        msg: json["msg"],
        data:
            List<CityList>.from(json["data"].map((x) => CityList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CityList {
  int? id;
  String? name;
  String? city;
  String? slug;
  Default? datumDefault;
  dynamic lat;
  double? lng;
  int? status;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? phone;

  CityList({
    this.id,
    this.name,
    this.city,
    this.slug,
    this.datumDefault,
    this.lat,
    this.lng,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.phone,
  });

  factory CityList.fromJson(Map<String, dynamic> json) => CityList(
        id: json["id"],
        name: json["name"],
        city: json["city"],
        slug: json["slug"],
        datumDefault: defaultValues.map[json["default"]]!,
        lat: json["lat"],
        lng: json["lng"]?.toDouble(),
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "slug": slug,
        "default": defaultValues.reverse[datumDefault],
        "lat": lat,
        "lng": lng,
        "status": status,
        "is_deleted": isDeleted,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "phone": phone,
      };
}

enum Default { YES }

final defaultValues = EnumValues({"Yes": Default.YES});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
