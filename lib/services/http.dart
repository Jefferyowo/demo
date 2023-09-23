import 'package:http/http.dart' as http;
import 'dart:convert';

class APIservice {
  // 新增行程
  // static Future<List> addJourney(
  //     {required Map<String, dynamic> content}) async {
  //   String url =
  //       Uri.encodeFull("http://163.22.17.145:3000/api/add_journey"); //api後接檔案名稱
  //   final response = await http.post(Uri.parse(url),
  //       body: jsonEncode(content)); // 根據使用者的token新增資料
  //   try {
  //     final responseString = response.body;
  //     final responseData = jsonDecode(responseString);
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       print('server新增行程成功');
  //       return [true, responseData];
  //     } else {
  //       throw Exception(responseData['message']);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [false, e.toString()];
  //   }
  // }

  // static Future<List> addJourney(
  //     {required Map<String, dynamic> content}) async {
  //   String url = "http://163.22.17.145:3000/api/journey/add_event";

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Charset': 'utf-8'
  //         // 如果需要其他headers，也可以在這裡加入
  //       },
  //       body: jsonEncode(content),
  //     );
  //     // final encodeFirst = json.encode(response.body);
  //     // final data = json.decode(encodeFirst);
  //     final responseString = jsonDecode(response.body);
  //     if (responseString.statusCode == 200 ||
  //         responseString.statusCode == 400) {
  //       print('server新增行程成功');
  //       return [true, responseString];
  //     } else {
  //       print(responseString);
  //       return [false, responseString];
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [false, e.toString()];
  //   }
  // }

  // static Future<List> addJourney(
  //     {required Map<String, dynamic> content}) async {
  //   String url = "http://163.22.17.145:3000/api/journey/";
  //   final response = await http.post(Uri.parse(url), body: jsonEncode(content));
  //   print(content);
  //   print(response.body);
  //   final responseString = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 400) {
  //     return [true, responseString];
  //   } else {
  //     return [false, response];
  //   }
  // }
  static Future<List<dynamic>> addJourney(
      {required Map<String, dynamic> content}) async {
    final url = Uri.parse("http://163.22.17.145:3000/api/journey/");

    try {
      final response = await http.post(
        url,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(content),
      );

      if (response.statusCode == 200) {
        // 解析JSON數據
        final List<dynamic> journeyData = jsonDecode(response.body);
        return journeyData;
      } else {
        // 處理錯誤情況
        throw Exception("無法檢索資料：${response.statusCode}");
      }
    } catch (e) {
      // 處理例外情況
      throw Exception("無法連接到伺服器：$e");
    }
  }
  // static Future<List> addJourney() async {
  //   String url = "http://163.22.17.145:3000/api/journey/";
  //   try {
  //     final response = await http.post(Uri.parse(url),
  //         body: jsonEncode({
  //           'uID': 1,
  //           'journeyName': 1,
  //           'location': 1,
  //           'journeyStartTime': 1,
  //           'journeyEndTime': 1,
  //           'color': 1,
  //           'remark': 1,
  //           'remindTime': 1,
  //           'remindStatus': 1,
  //           'isAllDay': 1
  //         }));
  //     final responseString = jsonDecode(response.body);
  //     print(response.statusCode);
  //     if (response.statusCode == 200 || response.statusCode == 400) {
  //       return [true, responseString];
  //     } else {
  //       return [false, response];
  //     }
  //   } catch (e) {
  //     return [false, e];
  //   }
  // }

  // // 編輯行程
  // static Future<List> editJourney(
  //     {required Map<String, dynamic> content}) async {
  //   String url = "http://163.22.17.145:3000/api/"; //api後接檔案名稱
  //   final response = await http.post(Uri.parse(url),
  //       headers: {'cookie': UserData.token}, body: content); // 根據使用者的token新增資料
  //   final responseString = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 400) {
  //     print('編輯行程成功');
  //     return [true, responseString];
  //   } else {
  //     print(responseString);
  //     return [false, responseString];
  //   }
  // }

  // // 刪除行程
  // static Future<List> deleteJourney(
  //     {required Map<String, dynamic> content}) async {
  //   String url = "http://163.22.17.145:3000/api/"; //api後接檔案名稱
  //   final response = await http.post(Uri.parse(url),
  //       headers: {'cookie': UserData.token}, body: content); // 根據使用者的token新增資料
  //   final responseString = jsonDecode(response.body);
  //   if (response.statusCode == 200 || response.statusCode == 400) {
  //     print('刪除行程成功');
  //     return [true, responseString];
  //   } else {
  //     print(responseString);
  //     return [false, responseString];
  //   }
  // }
}
