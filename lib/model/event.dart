import 'package:flutter/material.dart';

class Event {
  final int? jID; //
  final String? uID;
  final String journeyName; //
  final DateTime journeyStartTime; //
  final DateTime journeyEndTime; //
  final Color color; //
  final String location; //
  final String remark; //
  final int remindTime; //
  final bool remindStatus;
  final bool isAllDay;

  const Event({
    this.jID,
    this.uID,
    required this.journeyName,
    required this.journeyStartTime,
    required this.journeyEndTime,
    this.color = Colors.black,
    this.location = '',
    this.remark = '',
    this.remindTime = 0,
    this.remindStatus = false,
    this.isAllDay = false,
  });

  get start => null;

  factory Event.fromMap(Map<String, dynamic> map) {
    int journeyStartTimeInt = map['journeyStartTime'];
    int journeyEndTimeInt = map['journeyEndTime'];

    DateTime journeyStartTime = DateTime(
        journeyStartTimeInt ~/ 100000000, // 年
        (journeyStartTimeInt % 100000000) ~/ 1000000, // 月
        (journeyStartTimeInt % 1000000) ~/ 10000, // 日
        (journeyStartTimeInt % 10000) ~/ 100, // 小时
        journeyStartTimeInt % 100 // 分钟
        );

    DateTime journeyEndTime = DateTime(
        journeyEndTimeInt ~/ 100000000, // 年
        (journeyEndTimeInt % 100000000) ~/ 1000000, // 月
        (journeyEndTimeInt % 1000000) ~/ 10000, // 日
        (journeyEndTimeInt % 10000) ~/ 100, // 小时
        journeyEndTimeInt % 100 // 分钟
        );
    return Event(
      jID: map['jID'],
      uID: map['uID'],
      journeyName: map['journeyName'],
      journeyStartTime: journeyStartTime,
      journeyEndTime: journeyEndTime,
      color: Color(map['color']),
      location: map['location'],
      remark: map['remark'],
      remindTime: map['remindTime'],
      remindStatus: map['remindStatus'] == 1,
      isAllDay: map['isAllDay'] == 1,
    );
  }
  // journeyStartTime.year * 100000000 +journeyStartTime.month * 1000000 +journeyStartTime.day * 10000 +journeyStartTime.hour * 100 +journeyStartTime.minute
  Map<String, dynamic> toMap() {
    return {
      'jID': jID,
      'journeyName': journeyName,
      'uID': uID,
      'journeyStartTime': journeyStartTime.year * 100000000 +
          journeyStartTime.month * 1000000 +
          journeyStartTime.day * 10000 +
          journeyStartTime.hour * 100 +
          journeyStartTime.minute, // 將 DateTime 轉換為 ISO 8601 字串
      'journeyEndTime': journeyEndTime.year * 100000000 +
          journeyEndTime.month * 1000000 +
          journeyEndTime.day * 10000 +
          journeyEndTime.hour * 100 +
          journeyEndTime.minute, // 將 DateTime 轉換為 ISO 8601 字串
      'color': color.value, // 將 Color 轉換為整數
      'location': location,
      'remark': remark,
      'remindTime': remindTime,
      'remindStatus': remindStatus ? 1 : 0, // 將 bool 轉換為整數
      'isAllDay': isAllDay ? 1 : 0, // 將 bool 轉換為整數
    };
  }
}
