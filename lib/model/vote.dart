import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

class Vote {
  final int? vID;
  final int? eID;
  final String? uID; // 新增的id属性
  final String voteName;
  final DateTime endTime;
  final bool singleOrMultipleChoice;

  // String id;

  // 构造函数，用于初始化对象
  const Vote({
    required this.vID,
    required this.eID,
    required this.uID, 
    required this.voteName,
    required this.endTime,
    required this.singleOrMultipleChoice,
    // required this.id,
    // required this.votingOptionContent,
    // required this.optionVotes,
  });

  get start => null;

  factory Vote.fromMap(Map<String, dynamic> map) {
    int endTimeInt = map['endTime'];

    DateTime endTime = DateTime(
        endTimeInt ~/ 100000000, // 年
        (endTimeInt % 100000000) ~/ 1000000, // 月
        (endTimeInt % 1000000) ~/ 10000, // 日
        (endTimeInt % 10000) ~/ 100, // 小时
        endTimeInt % 100 // 分钟
        );
    return Vote(
      vID: map['vID'],
      eID: map['eID'],
      uID: map['uID'],
      voteName: map['voteName'],
      endTime: endTime,
      singleOrMultipleChoice: map['singleOrMultipleChoice'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vID': vID,
      'eID': eID,
      'uID': uID,
      'voteName': voteName,
      'endTime': endTime.year * 100000000 +
          endTime.month * 1000000 +
          endTime.day * 10000 +
          endTime.hour * 100 +
          endTime.minute, // 將 DateTime 轉換為 ISO 8601 字串
      'singleOrMultipleChoice': singleOrMultipleChoice? 1 : 0,
    };
  }
}

class VoteOption {
  final int? oID;
  final int? vID;
  final List<String> votingOptionContent;
  final List<int> optionVotes;

  const VoteOption({
    required this.oID,
    required this.vID,
    required this.votingOptionContent,
    required this.optionVotes,
  });

  get start => null;

  Map<String, dynamic> toMap() {
    return {
      'vID': vID,
      'votingOptionContent': votingOptionContent,
      //'optionVotes': optionVotes,
    };
  }
}
