// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, avoid_print
import 'package:create_event2/page/event_editing_page.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:create_event2/utils.dart';
import 'package:create_event2/model/event.dart';
import 'package:create_event2/page/event_viewing_page.dart';
import 'package:create_event2/services/sqlite.dart';

class SelectedDayViewingPage extends StatefulWidget {
  const SelectedDayViewingPage({
    super.key,
  });

  @override
  State<SelectedDayViewingPage> createState() => _SelectedDayViewingPageState();
}

class _SelectedDayViewingPageState extends State<SelectedDayViewingPage> {
  List<Event> selectedDayEvent = []; // 存選擇當天行程的資料
  List<Event> eventTest = [];

  @override
  void initState() {
    final provider = Provider.of<EventProvider>(context, listen: false);
    provider.fetchEventsFromDatabase();
    selectedDayEvent.clear();
    fetchSelectedDayEvent();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchSelectedDayEvent() async {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final selectedDate = provider.selectedDate;
    //final allEvents = provider.getEvents();
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable = await Sqlite.queryAll(tableName: 'journey');
    queryCalendarTable ??= [];
    setState(() {
      eventTest = queryCalendarTable!.map((e) => Event.fromMap(e)).toList();
    });

    setState(() {
      selectedDayEvent = eventTest.where((event) {
        // 判斷行程是否在時間內
        final startDateTime = event.journeyStartTime;
        final endDateTime = event.journeyEndTime;
        final startDate = DateTime(
            startDateTime.year, startDateTime.month, startDateTime.day);
        final endDate =
            DateTime(endDateTime.year, endDateTime.month, endDateTime.day);
        // 起始時間-1,結束時間+1的區間來判斷
        return selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            selectedDate.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
      print('當天行程抓資料');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Utils.day(provider.selectedDate),
            style: TextStyle(fontSize: 40),
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
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventEditingPage(
                      addTodayDate: true,
                      time: DateTime(
                          provider.selectedDate.year,
                          provider.selectedDate.month,
                          provider.selectedDate.day,
                          DateTime.now().hour,
                          DateTime.now().minute),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   '  個人行程：',
            //   style: TextStyle(fontSize: 30),
            // ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedDayEvent.length,
                    itemBuilder: (context, index) {
                      final event = selectedDayEvent[index];
                      return Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: event.color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 47,
                            width: 5,
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                event.journeyName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    '起始時間：${Utils.toDateTime(event.journeyStartTime)}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '結束時間：${Utils.toDateTime(event.journeyEndTime)}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final backPage =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventViewingPage(event: event),
                                  ),
                                );
                                if (backPage != null) {
                                  setState(() {
                                    fetchSelectedDayEvent();
                                    print(backPage);
                                    print('重新更新頁面');
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ))
          ],
        ));
  }
}
