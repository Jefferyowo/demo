import 'package:create_event2/model/vote.dart'; // 引入投票模型
import 'package:create_event2/page/vote/vote_result.dart'; // 引入投票結果頁面
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../provider/vote_provider.dart'; // 引入投票提供者
import '../../services/http.dart'; // 引入HTTP服務
import 'package:http/http.dart' as http;

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
    getallResult();
  }

  getallResult() async {
    try {
      final result = await APIservice.seletallVoteResult(
          vID: widget.vote.vID, userMall: '1113'); //注意vID
      print('伺服器返回的結果: $result');

      if (result != null && result.isNotEmpty) {
        if (result is List &&
            result.length == 2 &&
            result[1] is List &&
            result[1].isNotEmpty &&
            result[1][0] is Map) {
          int? selectedOptionIndexFromServer = result[1][0]['oID'];
          if (selectedOptionIndexFromServer != null) {
            setState(() {
              selectedOptionIndex = selectedOptionIndexFromServer;
              print('抓投票結果成功: $selectedOptionIndexFromServer');
            });
          } else {
            print('伺服器返回的 oID 為空');
          }
        } else {
          // 顯示未投票的提示，並將 selectedOptionIndex 設置為一個無效值
          setState(() {
            selectedOptionIndex = -1;
          });
          print('未投票');
        }
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
                          selectedOptionIndex = value!;
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
                  // onPressed: () async {
                  //   if (selectedOptionIndex != -1) {
                  //     VoteResult voteResult = VoteResult(
                  //       voteResultID: 1,
                  //       vID: widget.vote.vID,
                  //       userMall: '1113',
                  //       oID: selectedOptionIndex,
                  //     );

                  //     try {
                  //       final result = await APIservice.addVoteResult(
                  //           content: voteResult.toMap());
                  //       print('API 回傳結果: $result');

                  //       if (result != null && result.isNotEmpty) {
                  //         bool success = result[0];
                  //         http.Response response = result[1];

                  //         if (success && response.statusCode == 200) {
                  //           // 投票結果成功新增至資料庫
                  //           Provider.of<VoteProvider>(context, listen: false)
                  //               .addVoteResult(voteResult);

                  //           Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => VoteResultPage(
                  //                 options: widget.voteOptions
                  //                     .map((e) =>
                  //                         e.votingOptionContent.join(", "))
                  //                     .toList(),
                  //                 voteName: widget.vote.voteName,
                  //               ),
                  //             ),
                  //           );
                  //         } else {
                  //           // 投票結果新增失敗
                  //           print('新增投票結果失敗');
                  //           print('回應內容: ${response.body}');
                  //           // 如果需要，您可以根据不同的状态码进行不同的处理
                  //         }
                  //       } else {
                  //         // 如果返回的 result 为 null 或为空，也可进行相应处理
                  //         print('API 回傳結果為空或無效');
                  //       }
                  //     } catch (e) {
                  //       print('在新增投票結果時發生錯誤: $e');
                  //     }
                  //   }
                  // }
                  onPressed: () async {
                    if (selectedOptionIndex != -1) {
                      // Check if the user has already voted
                      if (selectedOptionIndex != -1) {
                        // User has already voted, update the existing vote result
                        VoteResult voteResult = VoteResult(
                          voteResultID:
                              1, // Use the appropriate voteResultID from your logic
                          vID: widget.vote.vID,
                          userMall: '1113',
                          oID: selectedOptionIndex,
                        );

                        try {
                          final result = await APIservice.updateResult(
                              content: voteResult.toMap(), voteResultID: 15);
                          print('API 回傳結果: $result');

                          if (result != null && result.isNotEmpty) {
                            bool success = result[0];
                            http.Response response = result[1];

                            if (success && response.statusCode == 200) {
                              // VoteResult result successfully updated in the database
                              // Provider.of<VoteProvider>(context, listen: false)
                              //     .updateVote(voteResult);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VoteResultPage(
                                    options: widget.voteOptions
                                        .map((e) =>
                                            e.votingOptionContent.join(", "))
                                        .toList(),
                                    voteName: widget.vote.voteName,
                                  ),
                                ),
                              );
                            } else {
                              // Update vote result failed
                              print('更新投票結果失敗');
                              print('回應內容: ${response.body}');
                              // Handle different status codes if needed
                            }
                          } else {
                            // If the result is null or empty, handle accordingly
                            print('API 回傳結果為空或無效');
                          }
                        } catch (e) {
                          print('在更新投票結果時發生錯誤: $e');
                        }
                      } else {
                        // User hasn't voted, add a new vote result
                        VoteResult voteResult = VoteResult(
                          voteResultID:
                              0, // Set to an appropriate value, or generate a unique ID
                          vID: widget.vote.vID,
                          userMall: '1113',
                          oID: selectedOptionIndex,
                        );

                        try {
                          final result = await APIservice.addVoteResult(
                              content: voteResult.toMap());
                          print('API 回傳結果: $result');

                          if (result != null && result.isNotEmpty) {
                            bool success = result[0];
                            http.Response response = result[1];

                            if (success && response.statusCode == 200) {
                              // New vote result successfully added to the database
                              Provider.of<VoteProvider>(context, listen: false)
                                  .addVoteResult(voteResult);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VoteResultPage(
                                    options: widget.voteOptions
                                        .map((e) =>
                                            e.votingOptionContent.join(", "))
                                        .toList(),
                                    voteName: widget.vote.voteName,
                                  ),
                                ),
                              );
                            } else {
                              // Add new vote result failed
                              print('新增投票結果失敗');
                              print('回應內容: ${response.body}');
                              // Handle different status codes if needed
                            }
                          } else {
                            // If the result is null or empty, handle accordingly
                            print('API 回傳結果為空或無效');
                          }
                        } catch (e) {
                          print('在新增投票結果時發生錯誤: $e');
                        }
                      }
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
