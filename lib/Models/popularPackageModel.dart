import 'dart:convert';

PopularPackageModel welcomeFromJson(String str) =>
    PopularPackageModel.fromJson(json.decode(str));

String welcomeToJson(PopularPackageModel data) => json.encode(data.toJson());

class PopularPackageModel {
  int status;
  String msg;
  List<PopularPackageModelList> data;

  PopularPackageModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory PopularPackageModel.fromJson(Map<String, dynamic> json) =>
      PopularPackageModel(
        status: json["status"],
        msg: json["msg"],
        data: List<PopularPackageModelList>.from(
            json["data"].map((x) => PopularPackageModelList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PopularPackageModelList {
  int id;
  String name;
  int mrp;
  int price;
  int noOfParameter;
  List<ParameterList> parameterList;
  List<Frqlist> frqlist;
  List<Review> review;
  Discount discount;

  PopularPackageModelList({
    required this.id,
    required this.name,
    required this.mrp,
    required this.price,
    required this.noOfParameter,
    required this.parameterList,
    required this.frqlist,
    required this.review,
    required this.discount,
  });

  factory PopularPackageModelList.fromJson(Map<String, dynamic> json) =>
      PopularPackageModelList(
        id: json["id"] ?? 0,
        name: json["name"] != null ? json["name"] : '',
        mrp: json["mrp"] != null ? json["mrp"] : 0,
        price: json["price"] != null ? json["price"] : 0,
        noOfParameter:
            json["no_of_parameter"] != null ? json["no_of_parameter"] : 0,
        parameterList: List<ParameterList>.from(
            json["parameter_list"].map((x) => ParameterList.fromJson(x))),
        frqlist:
            List<Frqlist>.from(json["frqlist"].map((x) => Frqlist.fromJson(x))),
        review:
            List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        discount: Discount.fromJson(json["discount"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mrp": mrp,
        "price": price,
        "no_of_parameter": noOfParameter,
        "parameter_list":
            List<dynamic>.from(parameterList.map((x) => x.toJson())),
        "frqlist": List<dynamic>.from(frqlist.map((x) => x.toJson())),
        "review": List<dynamic>.from(review.map((x) => x.toJson())),
        "discount": discount,
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
        question: json["question"] != null ? json["question"] : '',
        ans: json["ans"] != null ? json["ans"] : '',
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
  String name;
  int id;
  int type;
  List<Parameter> parameter;

  ParameterList({
    required this.name,
    required this.id,
    required this.type,
    required this.parameter,
  });

  factory ParameterList.fromJson(Map<String, dynamic> json) => ParameterList(
        name: json["name"] != null ? json["name"] : '',
        id: json["id"] != null ? json["id"] : 0,
        type: json["type"] != null ? json["type"] : 0,
        parameter: json["parameter"] != null
            ? List<Parameter>.from(
                json["parameter"].map((x) => Parameter.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "type": type,
        "parameter": List<dynamic>.from(parameter.map((x) => x.toJson())),
      };
}

class Parameter {
  String name;
  int id;

  Parameter({
    required this.name,
    required this.id,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        name: json["name"] != null ? json["name"] : '',
        id: json["id"] != null ? json["id"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

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
        userId: json["user_id"] != null ? json["user_id"] : 0,
        ratting: json["ratting"] != null ? json["ratting"] : 0,
        date: json["date"] != null ? json["date"] : '',
        description: json["description"] != null ? json["description"] : '',
        username: json["username"] != null ? json["username"] : '',
        profilePic: json["profile_pic"] != null ? json["profile_pic"] : '',
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
