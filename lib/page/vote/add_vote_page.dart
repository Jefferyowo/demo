// ignore_for_file: prefer_const_constructors, avoid_print
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
  List<String> options = ['']; //['a']
  //options.add(B選項)
  //['a','b']
  List<int> optionVotes = []; // 票數

  // 添加选项的函数
  void addOption() {
    // 更新状态，添加一个空字符串到选项列表
  setState(() {
    options.add('');
    print(options);
  });
}


  // Future<Vote?> getvoteDataFromDatabase(int vid) async {
  //   List<Map<String, dynamic>>? queryResult = await Sqlite.queryRow(
  //       tableName: 'vote', key: 'vID', value: vid.toString());

  //   if (queryResult != null && queryResult.isNotEmpty) {
  //     Map<String, dynamic> voteData = queryResult.first;
  //     return Vote(
  //       vID: voteData['vID'],
  //       eID: voteData['eID'],
  //       userMall: voteData['userMall'],
  //       voteName: voteData['voteName'],
  //       endTime: DateTime(
  //           voteData['endTime'] ~/ 100000000, // 年
  //           (voteData['endTime'] % 100000000) ~/ 1000000, // 月
  //           (voteData['endTime'] % 1000000) ~/ 10000, // 日
  //           (voteData['endTime'] % 10000) ~/ 100, // 小时
  //           voteData['endTime'] % 100 // 分钟
  //           ),
  //       singleOrMultipleChoice: voteData['singleOrMultipleChoice'] == 1,
  //     );
  //   } else {
  //     return null;
  //   }
  // }

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
            buildOptions(),
            const SizedBox(height: 16.0),
            buildButtonAdd(),
            const SizedBox(height: 16.0),
            buildDateTimePickers(),
            const SizedBox(height: 16.0),
            buildCheckBox(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFCFE3F4), // 设置按钮的背景颜色
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
              onPressed: saveForm,
            )
          ],
        )),
      ),
    );
  }

  //建立標題
  Widget buildTitle() {
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

  //建立投票選項
  Widget buildOptions() {
    return Column(
      children: [
        const Text(
          '投票選項 :',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          children: options.asMap().entries.map((entry) {
            int index = entry.key;
            return Row(
              children: [
                Expanded(
                    child: TextFormField(
                  onChanged: (value) {
                    options[index] = value;
                  },
                  decoration: InputDecoration(
                    labelText: '選項 ${index + 1}',
                  ),
                )),
                IconButton(
                  onPressed: () {
                    setState(() {
                      options.removeAt(index); // 移除选项
                    });
                  },
                  icon: const Icon(Icons.cancel),
                )
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildButtonAdd() {
    return ElevatedButton(
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
    );
  }

  // 建立是否多選的選項
  Widget buildCheckBox() {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('一人多選'),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
          ),
        )
      ],
    );
  }

  // 建立結束時間
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
      setState(() {
        endTime = date;
      });
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

  // 儲存
  Future saveForm() async {
    String voteName = questionController.text;
    // 检查投票名称是否非空
    if (voteName.isNotEmpty) {
      // 从选项列表中过滤出非空选项
      List<String> updatedOptions =
          options.where((option) => option.isNotEmpty).toList();
      // 检查是否存在非空选项    
      if (updatedOptions.isNotEmpty) {
        // 生成一个包含所有选项初始投票数（均为0）的列表
        List<int> initialOptionVotes =
            List.generate(updatedOptions.length, (index) => 0);
        // 创建一个代表整体投票的Vote对象    
        Vote vote = Vote(
          vID: 1,
          eID: 123,
          userMall: '1112',
          voteName: voteName,
          endTime: endTime,
          singleOrMultipleChoice: isChecked,
        );
        // 创建一个包含所有选项信息的VoteOption对象
        VoteOption voteOption = VoteOption(
          oID: 1,
          vID: 1112,
          votingOptionContent: options, 
          // optionVotes: optionVotes
        );
        // 遍历每个选项并创建一个独立的VoteOption对象
        for (var element in options) {
          VoteOption voteOptiontest = VoteOption(
          oID: 1,
          vID: 1112,
          votingOptionContent: [element], //a
          // optionVotes: optionVotes
        );
        // 使用API service将单独的选项添加到数据库
        final result1 = await APIservice.addVoteOptions(content: voteOptiontest.toMap()); // 新增投票選項進資料庫
        }
        // 将整体的选项添加到Provider中
        Provider.of<VoteProvider>(context, listen: false).addVoteOptions(voteOption);
        // 将整体的投票添加到Provider中
        Provider.of<VoteProvider>(context, listen: false).addVote(vote);
        // Provider.of<VoteProvider>(context, listen: false).addVoteOptions(voteOption);

        // 使用API service将整体的投票添加到数据库
        final result = await APIservice.addVote(content: vote.toMap()); // 新增投票進資料庫
        // final result1 = await APIservice.addVoteOptions(content: voteOption.toMap());
        Navigator.pop(context);
      }
    }
  }
}
