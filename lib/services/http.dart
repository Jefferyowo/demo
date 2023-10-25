import 'package:create_event2/model/event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:create_event2/services/sqlite.dart';

class APIservice {
  static Future<List<dynamic>> addJourney(
      {required Map<String, dynamic> content}) async {
    final url =
        Uri.parse("http://163.22.17.145:3000/api/journey/insertJourney/");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  // 編輯行程
  static Future<List<dynamic>> editJourney(
      {required Map<String, dynamic> content, required int jID}) async {
    String url =
        "http://163.22.17.145:3000/api/journey/updateJourney/$jID"; //api後接檔案名稱
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      print('編輯行程成功');
      return [true, response];
    } else {
      print(response);
      return [false, response];
    }
  }

  // 刪除行程
  static Future<List<dynamic>> deleteJourney(
      {required Map<String, dynamic> content, required int jID}) async {
    String url =
        "http://163.22.17.145:3000/api/journey/deleteJourney/$jID"; //api後接檔案名稱
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    ); // 根據使用者的token新增資料
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('刪除行程成功');
      return [true, responseString];
    } else {
      print(responseString);
      return [false, responseString];
    }
  }
  // 新增投票
  static Future<List<dynamic>> addVote(
      {required Map<String, dynamic> content}) async {
    final url =
        Uri.parse("http://163.22.17.145:3000/api/vote/insertVote/");

    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return [true, responseString];
    } else {
      return [false, response];
    }
  }

  // 刪除投票
  static Future<List<dynamic>> deleteVote(
      {required Map<String, dynamic> content, required int vID}) async {
    String url =
        "http://163.22.17.145:3000/api/vote/deleteVote/$vID"; //api後接檔案名稱
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    ); // 根據使用者的token新增資料
    final responseString = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print('刪除行程成功');
      return [true, responseString];
    } else {
      print(responseString);
      return [false, responseString];
    }
  }
  // 抓全部資料route.get

  // 抓使用者行事曆資料
  static Future<void> selectAccountActivity(
      {required Map<String, dynamic> content, required String uID}) async {
    print('刷新 sqlite 活動資料表');
    String url = "http://163.22.17.145:3000/api/journey/$uID";
    await Sqlite.clear(tableName: "journey").then((value) async {
      await http
          .post(Uri.parse(url),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(content))
          .then((response) {
        final serverJourney = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 400) {
          for (var journey in serverJourney) {
            final Event newJourneyData = Event(
                jID: journey['jID'],
                uID: journey['uID'],
                journeyName: journey['jouurneyName'],
                journeyStartTime: journey['journeyStartTime'],
                journeyEndTime: journey['journeyEndTime'],
                color: journey['color'],
                location: journey['location'],
                remark: journey['remark'],
                remindTime: journey['remindTime'],
                remindStatus: journey['remindStatus'],
                isAllDay: journey['isAllDay']);
            Sqlite.insert(
                tableName: 'journey', insertData: newJourneyData.toMap());
            print('完成 刷新 sqlite 活動資料表');
            return [serverJourney];
          }
        } else {
          print('失敗 刷新 sqlite 活動資料表');
          print('失敗 $serverJourney response.statusCode ${response.statusCode}');
          return [serverJourney];
        }
      });
    });
  }

  static Future<List<dynamic>> selectAll(
      {required Map<String, dynamic> content, required String uID}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/journey/$uID");
    await Sqlite.clear(tableName: "journey");
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(content),
    );
    final serverJourney = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      for (var journey in serverJourney) {
        int journeyStartTimeInt = journey['journeyStartTime'];
        int journeyEndTimeInt = journey['journeyEndTime'];
        final Event newJourneyData = Event(
            jID: journey['jID'],
            uID: journey['uID'],
            journeyName: journey['journeyName'].toString(),
            journeyStartTime: DateTime(
                journeyStartTimeInt ~/ 100000000, // 年
                (journeyStartTimeInt % 100000000) ~/ 1000000, // 月
                (journeyStartTimeInt % 1000000) ~/ 10000, // 日
                (journeyStartTimeInt % 10000) ~/ 100, // 小时
                journeyStartTimeInt % 100 // 分钟
                ),
            journeyEndTime: DateTime(
                journeyEndTimeInt ~/ 100000000, // 年
                (journeyEndTimeInt % 100000000) ~/ 1000000, // 月
                (journeyEndTimeInt % 1000000) ~/ 10000, // 日
                (journeyEndTimeInt % 10000) ~/ 100, // 小时
                journeyEndTimeInt % 100 // 分钟
                ),
            color: Color(journey['color']),
            location: journey['location'],
            remark: journey['remark'],
            remindTime: journey['remindTime'],
            remindStatus: journey['remindStatus'] == 1,
            isAllDay: journey['isAllDay'] == 1);
        Sqlite.insert(tableName: 'journey', insertData: newJourneyData.toMap());
      }
      print('完成 刷新 sqlite 活動資料表');
      return serverJourney;
    } else {
      print('失敗 刷新 sqlite 活動資料表');
      print('失敗 $serverJourney response.statusCode ${response.statusCode}');
      return serverJourney;
    }
  }
}
