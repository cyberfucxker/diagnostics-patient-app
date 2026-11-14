// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

BannerModel bannerFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  int status;
  String filePath;
  String msg;
  List<String> appBanner;
  List<String> mainBanner;

  BannerModel({
    required this.status,
    required this.filePath,
    required this.msg,
    required this.appBanner,
    required this.mainBanner,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        status: json["status"],
        filePath: json["file_path"],
        msg: json["msg"],
        appBanner: List<String>.from(json["app_banner"].map((x) => x)),
        mainBanner: List<String>.from(json["main_banner"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "file_path": filePath,
        "msg": msg,
        "app_banner": List<dynamic>.from(appBanner.map((x) => x)),
        "main_banner": List<dynamic>.from(mainBanner.map((x) => x)),
      };
}
