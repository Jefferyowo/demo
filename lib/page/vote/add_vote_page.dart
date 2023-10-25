// add_vote_page.dart

import 'package:create_event2/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';
import '../../services/http.dart';
import '../../services/sqlite.dart';

class AddVotePage extends StatefulWidget {
  final Vote? vote;

  const AddVotePage({
    Key? key,
    this.vote,
  });
  @override
  _AddVotePageState createState() => _AddVotePageState();
}

class _AddVotePageState extends State<AddVotePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController questionController = TextEditingController();
  late DateTime endTime;
  bool isChecked = false;
  List<String> options = [''];
  List<int> optionVotes = [];

  void addOption() {
    setState(() {
      options.add('');
    });
  }

  Future<Vote?> getvoteDataFromDatabase(int vid) async {
    List<Map<String, dynamic>>? queryResult = await Sqlite.queryRow(
        tableName: 'vote', key: 'vID', value: vid.toString());

    if (queryResult != null && queryResult.isNotEmpty) {
      Map<String, dynamic> voteData = queryResult.first;
      return Vote(
          vID: voteData['vID'],
          eID: voteData['eID'],
          uID: voteData['uID'],
          voteName: voteData['voteName'],
          endTime: DateTime(
              voteData['endTime'] ~/ 100000000, // 年
              (voteData['endTime'] % 100000000) ~/ 1000000, // 月
              (voteData['endTime'] % 1000000) ~/ 10000, // 日
              (voteData['endTime'] % 10000) ~/ 100, // 小时
              voteData['endTime'] % 100 // 分钟
              ),
          singleOrMultipleChoice: voteData['singleOrMultipleChoice'] == 1,
          );
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增投票', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: const Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // 返回上一个页面
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              const SizedBox(height: 16.0),
              const Text(
                '投票選項',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: options.asMap().entries.map((entry) {
                  int index = entry.key;
                  return TextFormField(
                    onChanged: (value) {
                      options[index] = value;
                    },
                    decoration: InputDecoration(
                      labelText: '選項 ${index + 1}',
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                  ),
                ),
                child: Text(
                  "新增選項",
                  style: TextStyle(
                    color: Colors.black, // 设置文本颜色
                    fontSize: 15, // 设置字体大小
                    fontFamily: 'DFKai-SB', // 设置字体
                    fontWeight: FontWeight.w600, // 设置字体粗细
                  ),
                ),
                onPressed: addOption,
              ),
              const SizedBox(height: 16.0),
              buildDateTimePickers(),
              const SizedBox(height: 16.0),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('一人多選'),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                  ),
                ),
                child: Text(
                  "送出投票",
                  style: TextStyle(
                    color: Colors.black, // 设置文本颜色
                    fontSize: 15, // 设置字体大小
                    fontFamily: 'DFKai-SB', // 设置字体
                    fontWeight: FontWeight.w600, // 设置字体粗细
                  ),
                ),
                onPressed: () async {
                  String voteName = questionController.text;
                  if (voteName.isNotEmpty) {
                    List<String> updatedOptions =
                        options.where((option) => option.isNotEmpty).toList();

                    if (updatedOptions.isNotEmpty) {
                      List<int> initialOptionVotes =
                          List.generate(updatedOptions.length, (index) => 0);

                      Vote vote = Vote(
                        vID: 1,
                        eID: 1,
                        uID: '1',
                        voteName: voteName,
                        endTime: endTime,
                        singleOrMultipleChoice: isChecked,
                      );

                      Provider.of<VoteProvider>(context, listen: false)
                          .addVote(vote);
                      Navigator.pop(context);
                      final result = await APIservice.addVote(content: vote.toMap());
                    }
                  }
                },
          )],
          )),
      ),
    );
  }

  //建立標題
  Widget buildTitle(){
    return Row(
      children: [
        const Text(
          '名稱 ：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextFormField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: '請輸入標題',
            ),
            onFieldSubmitted: (_) => {},
            validator: (title) => title != null && title.isEmpty
                ? 'Title can not be empty'
                : null,
            controller: questionController,
          ),
        ),
      ],
    );
  }
  Widget buildDateTimePickers() => Column(
    children: [
      buildFrom(),
    ],
  );
  Widget buildFrom() {
    return buildHeader(
      header: '截止時間',
      child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                text: Utils.toDate(endTime),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropdownField(
                text: Utils.toTime(endTime),
                onClicked: () => pickFromDateTime(pickDate: false),
              ),
            )
          ],
        ),      
    );
  }
  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );
  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$header：',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          child,
        ],
     );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(endTime, pickDate: pickDate);

    if (date == null) return;
    // 起始時間 > 結束時間
    if (date.isAfter(endTime)) {
      // 年月日都一樣 判斷時間
      if (date.year == endTime.year &&
          date.month == endTime.month &&
          date.day == endTime.day) {
        // 起始小時>結束小時
        if (date.hour > endTime.hour) {
          // 結束小時+1
          endTime = DateTime(
              date.year, date.month, date.day, date.hour + 1, date.minute);
        }
        // 只有分鐘不同
        if (date.hour == endTime.hour) {
          if (date.minute > endTime.minute) {
            // 直接設跟起始一樣
            endTime = DateTime(
                date.year, date.month, date.day, date.hour, date.minute);
          }
        }
      } else {
        endTime = DateTime(
            date.year, date.month, date.day, endTime.hour, endTime.minute);
      }
    }
  }   
  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
      required bool pickDate,
      DateTime? firstDate,
    }) async {
      if (pickDate) {
        final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2015, 8),
          lastDate: DateTime(2101),
        );
        if (date == null) return null;
        final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }
  // Future saveForm() async {
  //   final provider = Provider.of<VoteProvider>(context, listen: false);
  //   // Provider.of<VoteProvider>(context, listen: false).addVote(newVote);Navigator.pop(context);
  //   // await Sqflite.initDatabase(); //
  //   // final isvalid = _formKey.currentState!.validate();
  //   String uID = 'q';
  //   int eID = 0;
  //   // if (isvalid) {
  //     final Vote vote = Vote(
  //         eID: eID,
  //         uID: uID,
  //         voteName: questionController.text,
  //         endTime: endTime,
  //         singleOrMultipleChoice: isChecked, 
  //         vID: null,
  //         // votingOptionContent: options,
  //         // optionVotes: optionVotes,
  //         );
  //     print(eID);
  //     print(uID);
  //     print(questionController.text);
  //     print(endTime.microsecondsSinceEpoch);
  //     print(isChecked);
  //     // await Sqlite.insert(tableName: 'journey', insertData: vote.toMap());
  //       final result = await APIservice.addVote(content: vote.toMap());
  //       print('投票!!!!!!');
  //       print(result[0]);
  //       if (result[0]) {
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           '/MyBottomBar2',
  //           ModalRoute.withName('/'),
  //         );
  //       } else {
  //         print('$result 在 server 新增投票失敗');
  //       }
  //   }
  // //}
}
