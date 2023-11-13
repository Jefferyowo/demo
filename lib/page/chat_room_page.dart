import 'package:create_event2/model/vote.dart';
import 'package:create_event2/page/vote/vote_page.dart';
import 'package:flutter/material.dart';

import '../services/http.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    Key? key,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  late DateTime endTime;
  bool isChecked = false;
  final List<String> _messages = [];
  late Vote _currentVote;

  @override
  void initState() {
    super.initState();
    //_currentVote = widget.vote;
  }

  void _sendMessage(String message) {
    setState(() {
      _messages.add(message);
      _messageController.clear();
    });
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.poll),
            title: Text('投票'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VotePage(),
                ),
              ); 
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聊天室'),
        leading: IconButton(
          // X 按鈕
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pushNamed(context, '/eventpage');
            Navigator.pop(context);
            // Navigator.pushReplacementNamed(context, '/eventpage');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.poll),
                                title: Text('投票'),
                                onTap: () {
                                  //getallVote();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VotePage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '輸入訊息...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // getallVote() async {
  //   final result = await APIservice.seletallVote(eID: 12345);
  //   print(result[0]);
  //   if (result[0]) {
  //     setState(() {
  //       //_votes = result[1];
  //     });
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       '/MyBottomBar2',
  //       ModalRoute.withName('/'),
  //     );
  //   } else {
  //     print('$result 在 server 抓取投票失敗');
  //   }
  // }
}
