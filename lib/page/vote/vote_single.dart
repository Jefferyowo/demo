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
                    if (selectedOptionIndex != -1) {
                      // 这里添加您的投票逻辑
                      VoteResult voteResult = VoteResult(
                        voteResultID: 1,
                        vID: widget.vote.vID,
                        userMall: '1113',
                        oID: selectedOptionIndex,
                      );

                      final result = await APIservice.addVoteResult(
                          content: voteResult.toMap());

                      Provider.of<VoteProvider>(context, listen: false)
                          .addVoteResult(voteResult);

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
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
