import 'package:create_event2/model/vote.dart'; // 引入投票模型
import 'package:create_event2/page/vote/vote_result.dart'; // 引入投票結果頁面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/vote_provider.dart'; // 引入投票提供者
import '../../services/http.dart'; // 引入HTTP服務

class SingleVote extends StatefulWidget {
  final Vote vote; // 投票對象
  final List<VoteOption> voteOptions; // 投票選項列表

  const SingleVote({
    Key? key,
    required this.vote,
    required this.voteOptions,
  }) : super(key: key);

  @override
  _SingleVoteState createState() => _SingleVoteState();
}

class _SingleVoteState extends State<SingleVote> {
  int selectedOptionIndex = -1; // 選中的選項索引
  List<String> options = [''];
  late List<dynamic> _voteOptions = [];

  @override
  void initState() {
    super.initState();
    //getallVoteOption();
    getallResult();
  }

  // getallVoteOption() async {
  //   VoteOption voteOption = VoteOption(
  //     oID: 1,
  //     vID: 1112,
  //     votingOptionContent: options,
  //   );
  //   final result = await APIservice.seletallVoteOptions(vID: 123);
  //   final List<VoteOption> test = [];
  //   print('getallVoteOption');
  //   print(result[1]);

  //   for (var map in result[1]) {
  //     test.add(VoteOption.fromMap(map));
  //   }

  //   // vid:115,votingOptionContent: B,N,M
  //   // print('result[1][2]');
  //   // print(result[1][2]);
  //   if (result[0]) {
  //     setState(() {
  //       _voteOptions = result[1].map((map) => VoteOption.fromMap(map)).toList();
  //     });
  //     print('voteOptions');
  //     print(_voteOptions);
  //   } else {
  //     print('$result 在 server 抓取投票選項失敗');
  //   }
  //   Provider.of<VoteProvider>(context, listen: false)
  //       .addVoteOptions(voteOption);
  // }

  getallResult() async {
    try {
      final result =
          await APIservice.seletallVoteResult(vID: widget.vote.vID, userMall: '1113'); //注意vID
      print('伺服器返回的結果: $result');

      if (result is List &&
          result.length == 2 &&
          result[1] is List &&
          result[1].isNotEmpty &&
          result[1][0] is Map) {
        int selectedOptionIndexFromServer = result[1][0]['oID'];
        setState(() {
          selectedOptionIndex = selectedOptionIndexFromServer;
          print('抓投票結果成功: $selectedOptionIndexFromServer');
        });
      } else {
        print('伺服器返回的結果不符合預期格式');
      }
    } catch (e) {
      print('在 server 抓取投票結果時發生錯誤: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 如果沒有有效的投票選項，顯示提示信息
    if (widget.voteOptions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('投票')),
        body: const Center(child: Text('没有可用的投票选项')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('投票', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A7DAB),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
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
                  itemCount: widget.voteOptions.length,
                  itemBuilder: (context, index) {
                    String optionText = widget
                        .voteOptions[index].votingOptionContent
                        .join(", ");
                    return RadioListTile(
                      title: Text(
                        optionText,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      value: index,
                      groupValue: selectedOptionIndex,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOptionIndex = value ?? -1;
                        });
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFCFE3F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "投票",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'DFKai-SB',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () async {
                      //updateVote();
                      if (selectedOptionIndex != -1) {
                        // 获取选中的选项
                        VoteOption selectedOption =
                            widget.voteOptions[selectedOptionIndex];
                        // 确保 selectedOption.oID 不为 null
                        if (selectedOption.oID != null) {
                          // 创建投票结果对象
                          VoteResult voteResult = VoteResult(
                            voteResultID: 1,
                            vID: widget.vote.vID,
                            userMall: '1113',
                            oID: selectedOption.oID,
                          );

                          // 调用更新投票的 API
                          // final result = await APIservice.updateResult(
                          //     voteResultID: voteResult.voteResultID);

                          Provider.of<VoteProvider>(context, listen: false)
                              .addVoteResult(voteResult);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VoteResultPage(
                                options: widget.voteOptions
                                    .map(
                                        (e) => e.votingOptionContent.join(", "))
                                    .toList(),
                                voteName: widget.vote.voteName,
                              ),
                            ),
                          );
                        }
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateVote() async {
    try {
      if (selectedOptionIndex != -1) {
        // 获取选中的选项
        VoteOption selectedOption = widget.voteOptions[selectedOptionIndex];
        // 确保 selectedOption.oID 不为 null
        if (selectedOption.oID != null) {
          // 创建投票结果对象
          VoteResult voteResult = VoteResult(
            voteResultID: 1,
            vID: widget.vote.vID,
            userMall: '1113',
            oID: selectedOption.oID,
          );

          // 调用更新投票的 API
          final result = await APIservice.updateResult(
              voteResultID: voteResult.voteResultID);

          // 如果更新成功，更新本地狀態
          if (result[0]) {
            Provider.of<VoteProvider>(context, listen: false)
                .addVoteResult(voteResult);

            // 導航到投票結果頁面
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VoteResultPage(
                  options: widget.voteOptions
                      .map((e) => e.votingOptionContent.join(", "))
                      .toList(),
                  voteName: widget.vote.voteName,
                ),
              ),
            );
          } else {
            print('更新投票選項失敗');
          }
        } else {
          print('voteResult.voteResultID 為 null');
        }
      }
    } catch (e) {
      print('更新投票選項時發生錯誤: $e');
    }
  }
}
