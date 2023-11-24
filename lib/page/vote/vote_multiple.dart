import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';
import '../../services/http.dart'; // 别忘了导入你的 Vote 类

class VoteCheckbox extends StatefulWidget {
  final Vote vote;
  //final List<VoteOption> voteOptions;

  VoteCheckbox({
    Key? key,
    required this.vote,
    //required this.voteOptions,
  }) : super(key: key);

  @override
  _VoteCheckboxState createState() => _VoteCheckboxState();
}

class _VoteCheckboxState extends State<VoteCheckbox> {
  int selectedOptionIndex = -1; // 選中的選項索引
  List<bool> selectedOptions = []; // 存储每个选项是否被选中的列表
  //List<int> optionVotes = []; // 存储每个选项的投票数量

  late List<dynamic> _voteOptions = [];

  @override
  void initState() {
    super.initState();
    getOption();
    //getallResults();
  }

  // 抓回選項內容
  getOption() async {
    print("-------------getOption-----------------");
    print(widget.vote.vID);

    final result = await APIservice.seletallVoteOptions(vID: widget.vote.vID);
    if (result[0]) {
      setState(() {
        _voteOptions = result[1].map((map) => VoteOption.fromMap(map)).toList();
      });
      print('voteOptions');
      print(_voteOptions);
    } else {
      print('$result 在 server 抓取投票選項失敗');
    }
  }

  getallResults() async {
    final result = await APIservice.seletallVoteResult(
        vID: widget.vote.vID, userMall: '1112'); // userMall要更改
    print('伺服器返回的結果: $result');

    // 檢查伺服器回傳的結果是否是一個 List
    if (result is List) {
      if (result.length >= 2 &&
          result[1] is List &&
          result[1].isNotEmpty &&
          result[1][0] is Map) {
        // 將伺服器返回的選項索引轉換為整數列表
        List<int> statisValues =
            result[1].map((item) => item['status']).cast<int>().toList();
        // List<int> selectedOptionIndexFromServer =
        //     result[1].map((item) => item['oID']).cast<int>().toList();
        setState(() {
          print('抓投票結果成功: $statisValues');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投票', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: const Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        iconTheme: const IconThemeData(color: Colors.black), // 將返回箭头设为黑色
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.vote.voteName,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _voteOptions.length,
              itemBuilder: (context, index) {
                String optionText =
                    _voteOptions[index].votingOptionContent.join(", ");

                return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      optionText,
                      //'${widget.voteOptions.votingOptionContent[index]} (${optionVotes[index]})',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    value: selectedOptions[index],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedOptions[index] = value ?? false;

                        // if (value ?? false) {
                        //   optionVotes[index]++;
                        // } else {
                        //   optionVotes[index]--;
                        // }
                      });
                    });
              }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // 设置按钮的圆角
                  ),
                ),
                child: const Text(
                  '投票',
                  style: TextStyle(
                    color: Colors.black, // 设置文本颜色
                    fontSize: 15, // 设置字体大小
                    fontFamily: 'DFKai-SB', // 设置字体
                    fontWeight: FontWeight.w600, // 设置字体粗细
                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoteResultPage(
                        voteName: widget.vote.voteName,
                        vID: widget.vote.vID,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
