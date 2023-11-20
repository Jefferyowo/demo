import 'package:create_event2/page/vote/vote_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/vote.dart';
import '../../provider/vote_provider.dart';
import '../../services/http.dart'; // 别忘了导入你的 Vote 类
import 'package:http/http.dart' as http;

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
      // 檢查伺服器回傳的結果是否是一個 List
      if (result is List) {
        if (result.length >= 2 &&
            result[1] is List &&
            result[1].isNotEmpty &&
            result[1][0] is Map) {
          // 將伺服器返回的選項索引轉換為整數列表    
          List<int> selectedOptionIndexFromServer =
              result[1].map((item) => item['oID']).cast<int>().toList();
          setState(() {
            selectedOptions =
                // 初始化與投票選項相同長度的 selectedOptions 列表，並將其所有值設為 false
                List<bool>.filled(widget.voteOptions.length, false);
            // 根據伺服器返回的選項索引列表，設置 selectedOptions 中對應的值    
            for (int i = 0; i < selectedOptions.length; i++) {
              selectedOptions[i] = selectedOptionIndexFromServer
                  .contains(widget.voteOptions[i].oID);
              //print();    
            }
            print('抓投票結果成功: $selectedOptionIndexFromServer');
          });
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
                // Get the selected option indexes
                List<int> selectedIndexes = [];
                for (int i = 0; i < selectedOptions.length; i++) {
                  if (selectedOptions[i]) {
                    selectedIndexes.add(i);
                    //selectedIndexes.add(widget.voteOptions[i].oID);
                  }
                }

                // Check if the user has already voted
                if (selectedIndexes.isNotEmpty) {
                  // User has already voted, update the existing vote result(s)
                  List<int?> selectedOptionIDs = selectedIndexes
                      //.where((i) => i >= 0 && i < widget.voteOptions.length)
                      .map((index) => widget.voteOptions[index].oID)
                      .toList();

                  // Assuming only one option can be selected at a time for updating
                  // int selectedOptionID = selectedOptionIDs[0] ?? 1;

                  // Create a list of VoteResult objects for each selected option
                  List<VoteResult> voteResults =
                      selectedOptionIDs.map((optionID) {
                    return VoteResult(
                      voteResultID:
                          1, // Use the appropriate voteResultID from your logic
                      vID: widget.vote.vID,
                      userMall: '1113',
                      oID: optionID,
                      status: true,
                    );
                  }).toList();

                  try {
                    // Use the appropriate API service method to update results for multiple options
                    for (VoteResult result in voteResults) {
                      final updateResult = await APIservice.updateResult(
                        content: result.toMap(),
                        voteResultID: 20,
                      );

                      // Handle the update result for each option here
                      print('API 回傳結果: $updateResult');
                    }

                    // Navigate to the result page after handling all selected options
                    Navigator.push(
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
                  } catch (e) {
                    // Handle any errors that occur during the update process
                    print('在更新投票結果時發生錯誤: $e');
                  }
                }

                // Add new vote result(s) for the options that are newly selected
                List<int?> newlySelectedOptionIDs = selectedIndexes
                    //.where((i) => i >= 0 && i < widget.voteOptions.length)
                    .map((i) => widget.voteOptions[i].oID)
                    .where((optionID) => optionID != null)
                    .toList();

                List<VoteResult> newVoteResults =
                    newlySelectedOptionIDs.map((optionID) {
                      print(optionID);
                  return VoteResult(
                    voteResultID:
                        1, // Set to an appropriate value or generate a unique ID
                    vID: widget.vote.vID,
                    userMall: '1112',
                    oID: optionID,
                    status: true
                  );
                }).toList();

                try {
                  // Use the appropriate API service method to add new vote results
                  for (VoteResult newVoteResult in newVoteResults) {
                    final result = await APIservice.addVoteResult(
                      content: newVoteResult.toMap(),
                    );

                    if (result != null && result.isNotEmpty) {
                      bool success = result[0];
                      http.Response response = result[1];

                      if (success && response.statusCode == 200) {
                        // New vote result successfully added to the database
                        Provider.of<VoteProvider>(context, listen: false)
                            .addVoteResult(newVoteResult);
                      } else {
                        // Handle the case where adding a new vote result fails
                        print('新增投票結果失敗');
                        print('回應內容: ${response.body}');
                        // Handle different status codes if needed
                      }
                    }
                  }
                } catch (e) {
                  // Handle any errors that occur while adding new vote results
                  print('在新增投票結果時發生錯誤: $e');
                }

                // Navigate to the result page after handling both cases
                Navigator.push(
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
