import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';
import '../../services/http.dart'; // 别忘了导入你的 Vote 类

class VoteCheckbox extends StatefulWidget {
  final Vote vote;
  final List<VoteOption> voteOptions;

  VoteCheckbox({
    Key? key,
    required this.vote,
    required this.voteOptions,
  }) : super(key: key);

  @override
  _VoteCheckboxState createState() => _VoteCheckboxState();
}

class _VoteCheckboxState extends State<VoteCheckbox> {
  List<bool> selectedOptions = []; // 存储每个选项是否被选中的列表
  //List<int> optionVotes = []; // 存储每个选项的投票数量

  @override
  void initState() {
    super.initState();
    // Initialize selectedOptions with false values
    selectedOptions = List<bool>.filled(widget.voteOptions.length, false);
    // Fetch results after initializing selectedOptions
    getallResults();
  }

  getallResults() async {
    try {
      final result = await APIservice.seletallVoteResult(
          vID: widget.vote.vID, userMall: '1113');
      print('伺服器返回的結果: $result');

      if (result == null) {
      print('伺服器回應為空');
      return;
      }
      print('伺服器返回的結果類型: ${result.runtimeType}');

      if (result is List) {
        if (result.length >= 2 && result[1] is List && result[1].isNotEmpty && result[1][0] is Map) {
        List<int> selectedOptionIndexFromServer = result[1].map((item) => item['oID']).cast<int>().toList();    
        setState(() {
          selectedOptions = List<bool>.filled(widget.voteOptions.length, false);
          for (int index in selectedOptionIndexFromServer) {
            if (index >= 0 && index < selectedOptions.length) {
              selectedOptions[index] = true;
            }
          }
            print('抓投票結果成功: $selectedOptionIndexFromServer');
        });
      } else {
        print('伺服器返回的結果不符合預期格式');
      }
    } 
  } catch (e) {
    print('在 server 抓取投票結果時發生錯誤: $e');
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
              itemCount: widget.voteOptions.length,
              itemBuilder: (context, index) {
                String optionText =
                    widget.voteOptions[index].votingOptionContent.join(", ");
                // if (index < optionVotes.length) {
                //   optionText = '$optionText (${optionVotes[index]})';
                // }
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
                // 獲取選中的選項的索引
                List<int> selectedIndexes = [];
                for (int i = 0; i < selectedOptions.length; i++) {
                  if (selectedOptions[i]) {
                    selectedIndexes.add(i);
                  }
                }

                // 將選中的選項的 oID 放入投票結果對象
                List<int?> selectedOptionIDs = selectedIndexes
                    .map((index) => widget.voteOptions[index].oID)
                    .toList();

                VoteResult voteResult = VoteResult(
                  voteResultID: 1,
                  vID: widget.vote.vID,
                  userMall: '1112',
                  oID: selectedOptionIDs.isNotEmpty
                      ? selectedOptionIDs[0]
                      : 1, // 這裡取第一個選中的選項的 oID,
                );

                final result = await APIservice.addVoteResult(
                    content: voteResult.toMap()); // 新增投票結果進資料庫

                Provider.of<VoteProvider>(context, listen: false)
                    .addVoteResult(voteResult);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoteResultPage(
                        //optionVotes: optionVotes,
                        options: widget.voteOptions
                            .map((e) => e.votingOptionContent.join(", "))
                            .toList(),
                        voteName: widget.vote.voteName,
                        //originalVote: widget.vote,
                      ), // 修改这里
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
