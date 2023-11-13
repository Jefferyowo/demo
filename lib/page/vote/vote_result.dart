import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';

class VoteResultPage extends StatefulWidget {
  //final VoteOption originalVote; // 将属性名称更改为originalVote，以避免与局部变量混淆

  final String voteName; // 投票問題的描述
  final List<String> options; // 投票選項的列表
  //final List<int> optionVotes; // 投票選項的票數列表

  VoteResultPage({ 
    //required this.originalVote,
    required this.voteName, // 投票問題的描述，必需的參數
    required this.options, // 投票選項的列表，必需的參數
    //required this.optionVotes, // 投票選項的票數列表，必需的參數
  });

  @override
  State<VoteResultPage> createState() => _VoteResultPageState();
}

class _VoteResultPageState extends State<VoteResultPage> {
  @override
  Widget build(BuildContext context) {
    // return Consumer<VoteProvider>(
    //   builder: (context, voteProvider, child) {
    //final voteOption = voteProvider.getVoteById(widget.originalVote.vID as String );

    // if (voteOption == null) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('投票结果'),
    //       actions: [
    //         IconButton(
    //           icon: Icon(Icons.close, color: Colors.black),
    //           onPressed: () {
    //             Navigator.pushReplacementNamed(context, '/vote');
    //           },
    //         ),
    //       ],
    //     ),
    //     body: Center(
    //       child: Text('投票结果未找到!'),
    //     ),
    //   );
    // }

    // 计算总票数
    // final totalVotes = voteOption.optionVotes.reduce((a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投票結果', style: TextStyle(color: Colors.black)),
        centerTitle: true, //標題置中
        backgroundColor: Color(0xFF4A7DAB), // 這裡設置 AppBar 的顏色
        iconTheme: IconThemeData(color: Colors.black), // 將返回箭头设为黑色

        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/vote');
            },
          ),
        ],
      ),
      body: // Stack(
          // children: [
          // Background Image
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/back.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child:
            Text(
              '${widget.voteName}',
              style:
                  TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.options.length, // 列表項目的總數，通常等於選項的數量
              //itemCount: voteOption.votingOptionContent.length,
              itemBuilder: (context, index) {
                print('Index: $index');
                print('Option: ${widget.options[index]}');
                //print('Votes: ${widget.optionVotes[index]}');
                return ListTile(
                  title: Text(
                    '${widget.options[index]}',
                    // '${voteOption.votingOptionContent[index]}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // subtitle: Text(
                  //   '票数:  ${widget.optionVotes[index]}',
                  //   // ${voteOption.optionVotes[index]}',
                  //   style:
                  //       TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  // ),
                );
              },
            ),
          ),
        ],
      ),
      // ],
      // ),
    );
  }
  //);
}
//}
