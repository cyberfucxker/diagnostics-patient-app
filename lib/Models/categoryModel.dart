// class CategoryModel {
//   String image;
//   String title;
//   String descript;
//
//   CategoryModel({required this.image, required this.title, required this.descript});
// }
//
// List<CategoryModel> categoryModelList = [
//   CategoryModel(
//     title: Anaemia[LANGUAGE_TYPE],
//     image: 'assets/home/Anaemia.png',
//     descript: Anaemia_Des[LANGUAGE_TYPE],
//   ),
//   CategoryModel(
//     title: Thyroid[LANGUAGE_TYPE],
//     image: 'assets/home/Thyroid.png',
//     descript: Thyroid_Des[LANGUAGE_TYPE],
//   ),
//   CategoryModel(
//     title: Bone[LANGUAGE_TYPE],
//     image: 'assets/home/Bone.png',
//     descript: Bone_Des[LANGUAGE_TYPE],
//   ),
//   CategoryModel(
//     title: Obesity[LANGUAGE_TYPE],
//     image: 'assets/home/Obesity.png',
//     descript: Obesity_Des[LANGUAGE_TYPE],
//   ),
//   CategoryModel(
//     title: Acidity[LANGUAGE_TYPE],
//     image: 'assets/home/Acidity.png',
//     descript: Acidity_Des[LANGUAGE_TYPE],
//   ),
//   CategoryModel(
//     title: Diabetes[LANGUAGE_TYPE],
//     image: 'assets/home/Diabetes.png',
//     descript: Diabetes_Des[LANGUAGE_TYPE],
//   ),
// ];

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

CategoryModel reviewModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String reviewModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    this.status,
    this.msg,
    this.categoryModelList,
  });

  int? status;
  String? msg;
  List<CategoryModelList>? categoryModelList;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        status: json["status"],
        msg: json["msg"],
        categoryModelList: List<CategoryModelList>.from(json["data"].map((x) => CategoryModelList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(categoryModelList!.map((x) => x.toJson())),
      };
}

class CategoryModelList {
  CategoryModelList({
    this.id,
    this.name,
    this.short_desc,
    this.image,
  });

  int? id;
  String? name;
  String? short_desc;
  dynamic image;

  factory CategoryModelList.fromJson(Map<String, dynamic> json) => CategoryModelList(
        id: json["id"],
        name: json["name"],
        short_desc: json["short_desc"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_desc": short_desc,
        "image": image,
      };
}
