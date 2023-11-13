import 'package:create_event2/page/vote/add_vote_page.dart';
import 'package:create_event2/page/vote/vote_multiple.dart';
import 'package:create_event2/page/vote/vote_single.dart';
import 'package:create_event2/provider/vote_provider.dart';
import 'package:create_event2/page/vote/voteList.dart';
import 'package:create_event2/services/http.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';

class VotePage extends StatefulWidget {
  const VotePage({
    Key? key,
  }) : super(key: key);

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  TextEditingController questionController = TextEditingController();
  late DateTime endTime;
  bool isChecked = false;
  List<String> options = ['']; 
  List<int> optionVotes = []; // 票數
  
  late Vote _currentVote;
  late List<dynamic> _votes = [];
  late List<dynamic> _voteOptions = [];
  // late List<VoteResult> _voteResults = [];

  @override
  void initState() {
    super.initState();
    endTime = DateTime.now();
    getallVote();
    getallVoteOption();
    // getallResult();
  }

  getallVote() async {
    String voteName = questionController.text;
    Vote vote = Vote(
      vID: 1,
      eID: 1,
      userMall: '1112',
      voteName: voteName,
      endTime: endTime,
      singleOrMultipleChoice: isChecked,
    );
    final result = await APIservice.seletallVote(eID: 1113);
    print(result[0]);
    if (result[0]) {
      setState(() {
        _votes = result[1].map((map) => Vote.fromMap(map)).toList();
      });
      
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   '/MyBottomBar2',
      //   ModalRoute.withName('/'),
      // );
    } else {
      print('$result 在 server 抓取投票失敗');
    }
    Provider.of<VoteProvider>(context, listen: false).addVote(vote);
  }

  getallVoteOption() async {
    VoteOption voteOption = VoteOption(
        oID: 1,
        vID: 1112,
        votingOptionContent: options,
        // optionVotes: optionVotes
    );
    final result = await APIservice.seletallVoteOptions(vID: 115);
    final List test = [];
    print(result[1]);
    print(result[1][1]);
    for (var i in result[1]){
      test.add(result[1][i].map((map) => VoteOption.fromMap(map)).toList());
    }
    print('123');
    print(test);
    // vid:115,votingOptionContent: B,N,M
    // print('result[1][2]');
    // print(result[1][2]);
    if (result[0]) {
      setState(() {
        _voteOptions = result[1].map((map) => VoteOption.fromMap(map)).toList();
      });
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   '/MyBottomBar2',
      //   ModalRoute.withName('/'),
      // );
    } else {
      print('$result 在 server 抓取投票選項失敗');
    }
    Provider.of<VoteProvider>(context, listen: false)
        .addVoteOptions(voteOption);
  }

  getallResult() async {
    final result = await APIservice.seletallVoteResult(vID: 1, uID: '1112');
    print(result[0]);
    if (result[0]) {
      // setState(() {
      //   _voteResults = result[1];
      // });
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/MyBottomBar2',
        ModalRoute.withName('/'),
      );
    } else {
      print('$result 在 server 抓取投票結果失敗');
    }
  }

  Future<void> _confirmDeleteDialog(BuildContext context, int index) async {
    final voteProvider = Provider.of<VoteProvider>(context, listen: false);

    // 返回一个对话框
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // 构建一个警告对话框
        return AlertDialog(
          title: Text('確認刪除此投票？'),
          actions: <Widget>[
            TextButton(
              child: Text('是'),
              onPressed: () async {
                // 调用API service删除投票和相关选项
                final List result =
                    await APIservice.deleteVote(vID: 105); // 刪除資料庫
                final List result1 =
                    await APIservice.deleteVoteOptions(vID: 1112); // 刪除資料庫
                print(result[0]);
                if (result[0]) {
                  // var result = await Sqlite.deleteJourney(
                  //   tableName: 'journey',
                  //   tableIdName: 'jid',
                  //   deleteId: _currentEvent.jID ?? 0,
                  // );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/MyBottomBar2',
                    ModalRoute.withName('/'),
                  );
                } else {
                  print('在server刪除投票失敗');
                }
                if (result1[0]) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/MyBottomBar2',
                    ModalRoute.withName('/'),
                  );
                } else {
                  print('在server刪除投票選項失敗');
                }
                // 从Provider中删除投票
                voteProvider.deleteVote(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('否'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final voteProvider = Provider.of<VoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投票列表', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Color(0xFF4A7DAB),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回上一页面
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVotePage(),
                ),
              );

              if (result != null && result is Vote) {
                voteProvider.addVote(result);
              }
            },
          ),
        ],
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
          ListView.builder(
            itemCount: _votes.length,
            // itemCount: voteProvider.votes.length,
            itemBuilder: (context, index) {
              if(_votes.isEmpty || _voteOptions.isEmpty){
                return Container(
                  child: Text("列表為空"),
                );
              }
              // 获取当前索引的投票和相应的投票选项
              final vote = _votes[index];
              //final vote = voteProvider.votes[index];
              final voteOption = _voteOptions[index];
              //final voteOption = voteProvider.voteoptions[index];
              //final voteResult = _voteResults[index];

              return Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Stack(
                  children: [
                    // 通过InkWell添加一个可点击的透明区域，用于导航到投票详情页
                    Positioned.fill(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VoteList(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vote.voteName,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '截止時間 : ${DateFormat('yyyy/MM/dd HH:mm').format(vote.endTime)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFCFE3F4), // 设置按钮的背景颜色
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30), // 设置按钮的圆角
                              ),
                            ),
                            child: const Text(
                              "投票",
                              style: TextStyle(
                                color: Colors.black, // 设置文本颜色
                                fontSize: 15, // 设置字体大小
                                fontFamily: 'DFKai-SB', // 设置字体
                                fontWeight: FontWeight.w600, // 设置字体粗细
                              ),
                            ),
                            onPressed: () {
                              
                              // 根据投票类型导航到不同的投票页面
                              if (vote.singleOrMultipleChoice) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VoteCheckbox(
                                      vote: vote,
                                      voteOption: voteOption,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SingleVote(
                                      vote: vote,
                                      voteOption: voteOption 
                                      //as VoteOption,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _confirmDeleteDialog(context, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
