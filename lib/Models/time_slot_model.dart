// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

TimeSlot timeSlotFromJson(String str) => TimeSlot.fromJson(json.decode(str));

String timeSlotToJson(TimeSlot data) => json.encode(data.toJson());

class TimeSlot {
  int status;
  String msg;
  List<TimeSlotList> data;

  TimeSlot({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        status: json["status"],
        msg: json["msg"],
        data: List<TimeSlotList>.from(json["data"].map((x) => TimeSlotList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  where(bool Function(dynamic timeSlot) param0) {}
}

class TimeSlotList {
  String timeslot;
  DateTime? tempDate;

  TimeSlotList({
    required this.timeslot,
    this.tempDate,
  });

  factory TimeSlotList.fromJson(Map<String, dynamic> json) => TimeSlotList(
        timeslot: json["timeslot"],
      );

  Map<String, dynamic> toJson() => {
        "timeslot": timeslot,
      };
}
