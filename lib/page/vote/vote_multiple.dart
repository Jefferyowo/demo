import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';
import '../../services/http.dart'; // 别忘了导入你的 Vote 类

class VoteCheckbox extends StatefulWidget {
  final Vote vote;
  final VoteOption voteOption;

  VoteCheckbox({required this.vote, required this.voteOption});

  @override
  _VoteCheckboxState createState() => _VoteCheckboxState();
}

class _VoteCheckboxState extends State<VoteCheckbox> {
  List<bool> selectedOptions = []; // 存储每个选项是否被选中的列表
  List<int> optionVotes = []; // 存储每个选项的投票数量

  @override
  void initState() {
    super.initState();
    selectedOptions =
        List<bool>.filled(widget.voteOption.votingOptionContent.length, false);
    optionVotes = List<int>.filled(
        widget.voteOption.votingOptionContent.length, 0); // 初始化投票数量为 0
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
              itemCount: widget.voteOption.votingOptionContent.length,
              itemBuilder: (context, index) {
                String optionText =
                    widget.voteOption.votingOptionContent[index];
                if (index < optionVotes.length) {
                  optionText = '$optionText (${optionVotes[index]})';
                }
                return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      optionText,
                      //'${widget.voteOption.votingOptionContent[index]} (${optionVotes[index]})',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    value: selectedOptions[index],
                    onChanged: (bool? value) {
                      setState(() {
                        selectedOptions[index] = value ?? false;

                        if (value ?? false) {
                          optionVotes[index]++;
                        } else {
                          optionVotes[index]--;
                        }
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
                VoteResult voteResult = VoteResult(
                  voteResultID: 1,
                  vID: 1,
                  userMall: '1112',
                  oID: 1,
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
                        options: widget.voteOption.votingOptionContent,
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
