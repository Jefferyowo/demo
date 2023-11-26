import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';

class VoteList extends StatefulWidget {
  final Vote vote;

  const VoteList({
    Key? key,
    required this.vote,
  }) : super(key: key);

  @override
  State<VoteList> createState() => _VoteListState();
}

class _VoteListState extends State<VoteList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VoteProvider>(
      builder: (context, voteProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('投票結果', style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Color(0xFF4A7DAB),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // 返回上一页面
              },
            ),
          ),
          body: ListView.builder(
            itemCount: voteProvider.votes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  widget.vote.voteName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
