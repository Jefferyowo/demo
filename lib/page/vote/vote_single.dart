import 'package:create_event2/model/vote.dart'; //
import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/vote_provider.dart';
import '../../services/http.dart';

class SingleVote extends StatefulWidget {
  final Vote vote;
  final VoteOption voteOption;
  //final VoteResult voteResult;

  SingleVote({
    required this.vote,
    required this.voteOption,
    //required this.voteResult
  });

  @override
  _SingleVoteState createState() => _SingleVoteState();
}

class _SingleVoteState extends State<SingleVote> {
  TextEditingController questionController = TextEditingController();
  int selectedOptionIndex = -1;
  //late List<int> optionVotes;

  @override
  void initState() {
    super.initState();
    final votingOptionContentLength =
        widget.voteOption.votingOptionContent.length;
    //optionVotes = List<int>.from(widget.voteOption.optionVotes ?? []);
    // optionVotes =
    //     List.from(widget.voteOption.optionVotes.isNotEmpty ? widget.voteOption.optionVotes : []); // 使用widget.vote.optionVotes的初始值
    // 扩展optionVotes以匹配votingOptionContent的长度
    // while (optionVotes.length < votingOptionContentLength) {
    //   optionVotes.add(0); // 或者添加其他默认值
    // }
  }

// 在vote函数中更新Vote对象
  void voteOption(int optionIndex) {
    final voteProvider = Provider.of<VoteProvider>(context, listen: false);

    setState(() {
      // 如果已經選擇了一個選項，並且新選擇的選項與先前選擇的選項不同，則減少先前選項的票數
      // if (selectedOptionIndex != -1 && selectedOptionIndex != optionIndex)
      //   optionVotes[selectedOptionIndex]--;

      // if (selectedOptionIndex == optionIndex) {
      //   selectedOptionIndex = -1;
      // } else {
      //   selectedOptionIndex = optionIndex;
      //   optionVotes[optionIndex]++;
      // }

      // 创建一个新的Vote对象来更新当前的投票状态
      final updatedVote = Vote(
          vID: widget.vote.vID,
          eID: widget.vote.eID,
          userMall: widget.vote.userMall,
          voteName: widget.vote.voteName,
          endTime: widget.vote.endTime,
          singleOrMultipleChoice: widget.vote.singleOrMultipleChoice);

      final updatedVoteOption = VoteOption(
        oID: widget.voteOption.oID,
        vID: widget.voteOption.vID,
        votingOptionContent: widget.voteOption.votingOptionContent,
        // optionVotes: widget.voteOption.optionVotes,
      );

      // 使用Provider来更新Vote对象
      voteProvider.updateVote(
        updatedVote,
        widget.vote,
        updatedVoteOption,
        widget.voteOption,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.voteOption.votingOptionContent.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('投票'),
        ),
        body: const Center(child: Text('没有可用的投票选项')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('投票', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: const Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        iconTheme: const IconThemeData(color: Colors.black), // 將返回箭头设为黑色
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.vote.voteName,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.voteOption.votingOptionContent.length,
                  itemBuilder: (context, index) {
                    String optionText =
                        widget.voteOption.votingOptionContent[index];
                    // if (index < optionVotes.length) {
                    //   optionText = '$optionText (${optionVotes[index]})';
                    // }
                    return RadioListTile(
                      title: Text(
                        optionText,
                        //'${widget.voteOption.votingOptionContent[index]}(${optionVotes[index]})',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      value: index,
                      groupValue: selectedOptionIndex,
                      onChanged: (int? value) {
                        if (value != null) voteOption(value);
                      },
                    );
                  },
                ),
              ),
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
                    "投票", // 修改按钮文本为 "投票"
                    style: TextStyle(
                      color: Colors.black, // 设置文本颜色
                      fontSize: 15, // 设置字体大小
                      fontFamily: 'DFKai-SB', // 设置字体
                      fontWeight: FontWeight.w600, // 设置字体粗细
                    ),
                  ),
                  onPressed: () async {
                    if (selectedOptionIndex != -1) {
                      // 进行额外的投票逻辑处理，例如更新数据库等。
                    }
                    VoteResult voteResult = VoteResult(
                      voteResultID: 1,
                      vID: 1113,
                      userMall: '1113',
                      oID: 1113,
                    );

                    final result = await APIservice.addVoteResult(
                        content: voteResult.toMap()); // 新增投票結果進資料庫

                    Provider.of<VoteProvider>(context, listen: false)
                        .addVoteResult(voteResult);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoteResultPage(
                          //optionVotes: optionVotes,
                          options: widget.voteOption.votingOptionContent,
                          voteName: widget.vote.voteName,
                          //originalVote: widget.vote,
                        ),
                      ),
                    );
                    
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future save() async {
    String voteName = questionController.text;
    if (voteName.isNotEmpty) {}
  }
}
