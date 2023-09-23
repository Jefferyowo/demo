// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:create_event2/provider/event_provider.dart';
// import 'package:get/get.dart';
//import 'package:provider/provider.dart';
import 'package:create_event2/model/event.dart';
import 'package:create_event2/utils.dart';
import 'package:create_event2/page/event_viewing_page.dart';
import 'package:create_event2/services/sqlite.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  List<Event> allList = [];
  List<Event> searchResults = []; // 存找到的event
  String searchString = '';

  @override
  void initState() {
    super.initState();
    //getCalendarDate();
    textController.text = '';
    searchResults.clear();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // getCalendarDate() async {
  //   //await Sqlite.dropDatabase();
  //   await Sqlite.open; //開啟資料庫
  //   List? queryCalendarTable = await Sqlite.queryAll(tableName: 'journey');
  //   queryCalendarTable ??= [];
  //   setState(() {
  //     allList = queryCalendarTable!.map((e) => Event.fromMap(e)).toList();
  //   });
  //   print('搜尋頁面從資料庫找資料');
  //   return queryCalendarTable;
  // }

  List<Event> searchEvents(String keyword) {
    return allList
        .where((event) =>
            event.journeyName.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  void updateSearchResults(String keyword) {
    setState(() {
      // final eventProvider =
      //    Provider.of<EventProvider>(context, listen: false);
      if (keyword.isNotEmpty) {
        // final filteredEvents = eventProvider.searchEvents(keyword);
        searchResults = searchEvents(keyword);
      } else {
        searchResults.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Event>> fetchData(String keyword) async {
      await Sqlite.open; //開啟資料庫
      List? queryCalendarTable = await Sqlite.queryAll(tableName: 'journey');
      queryCalendarTable ??= [];
      setState(() {
        allList = queryCalendarTable!.map((e) => Event.fromMap(e)).toList();
      });
      setState(() {
        if (keyword.isNotEmpty) {
          searchResults = searchEvents(keyword);
        } else {
          searchResults.clear();
        }
      });
      // 回傳資料
      return searchResults;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '搜尋',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: CloseButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/MyBottomBar2',
              ModalRoute.withName('/'),
            );
          },
        ),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(16.0),
          child: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  textController.clear();
                  setState(() {
                    searchResults.clear(); // 刪除輸入文字清空結果
                  });
                },
                icon: const Icon(Icons.close),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: '關鍵字',
            ),
            onChanged: (value) {
              searchString = value;
              final cursorPosition = textController.selection;
              textController.text = value;
              textController.selection = cursorPosition;
              updateSearchResults(value);
            },
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder(
                stream: Stream.fromFuture(fetchData(searchString)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List? events = snapshot.data as List<dynamic>?;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: events!.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        // Future<void> tap() async {
                        //   final updateresult = await Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           EventViewingPage(event: event),
                        //     ),
                        //   );
                        //   if (!mounted) return;
                        //   updateSearchResults(textController.text);
                        // }

                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: event.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 47,
                              width: 5,
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  event.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    Text(
                                      '起始時間：${Utils.toDateTime(event.from)}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      '結束時間：${Utils.toDateTime(event.to)}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventViewingPage(event: event),
                                    ),
                                  );
                                  // print('返回搜尋頁面');
                                  // print(searchString);
                                  // setState(() {
                                  //   getCalendarDate();
                                  //   searchResults = searchEvents(searchString);
                                  // });
                                },
                                // onTap: () async {
                                //   final updatedEvent =
                                //       await Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           EventViewingPage(event: event),
                                //     ),
                                //   );
                                //   if (updatedEvent != null) {
                                //     eventProvider.editEvent(updatedEvent, event);
                                //     updateSearchResults(textController.text);
                                //   }
                                // },
                                //onTap: tap ,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
