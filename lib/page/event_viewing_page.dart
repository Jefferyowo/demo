// ignore_for_file: prefer_const_constructors, unused_import, duplicate_ignore, avoid_print

import 'package:create_event2/page/event_editing_page.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:create_event2/services/http.dart';
// ignore: unused_import
import 'package:create_event2/utils.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:create_event2/model/event.dart';
import 'package:get/get.dart';
import 'package:create_event2/services/sqlite.dart';

class EventViewingPage extends StatefulWidget {
  final Event event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  _EventViewingPageState createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {
  late Event _currentEvent;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
  }

  getCalendarDate() async {
    //await Sqlite.dropDatabase();
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable = await Sqlite.queryAll(tableName: 'journey');
    queryCalendarTable ??= [];
    for (var element in queryCalendarTable) {
      print(element);
    }
    return queryCalendarTable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pop(_currentEvent);
          },
        ),
        actions: buildViewingActions(context, _currentEvent),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          Text(
            _currentEvent.journeyName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          buildDateTime(_currentEvent),
          const SizedBox(
            height: 24,
          ),
          buildLocation(_currentEvent),
          const SizedBox(
            height: 24,
          ),
          buildRemark(_currentEvent),
          const SizedBox(
            height: 24,
          ),
          buildNotification(_currentEvent, _currentEvent.remindTime)
        ],
      ),
    );
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? '全天起始日期：' : '起始時間：', event.journeyStartTime),
        buildDate(event.isAllDay ? '全天結束日期：' : '結束時間：', event.journeyEndTime),
      ],
    );
  }

  Widget buildDate(String date, DateTime dateTime) {
    final dateFormatter1 = DateFormat('E, d MMM yyyy HH:mm');
    final dateFormatter2 = DateFormat('E, d MMM yyyy');
    final dateString1 = dateFormatter1.format(dateTime);
    final dateString2 = dateFormatter2.format(dateTime);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            date,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          !_currentEvent.isAllDay ? dateString1 : dateString2,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget buildLocation(Event event) {
    return Row(
      children: [
        Icon(Icons.location_on_outlined),
        const SizedBox(
          width: 3,
        ),
        Text(
          '地點：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(event.location.isNotEmpty ? event.location : '無',
            style: TextStyle(fontSize: 18))
      ],
    );
  }

  Widget buildNotification(Event event, int notification) {
    if (event.remindStatus) {
      return Row(
        children: [
          Icon(Icons.alarm),
          const SizedBox(
            width: 3,
          ),
          Text(
            '提醒：',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(notification != 0 ? '$notification 分鐘' : '時間到提醒',
              style: TextStyle(fontSize: 18))
        ],
      );
    } else {
      return Row(
        children: const [
          Icon(Icons.notifications_off),
          SizedBox(width: 3),
          Text(
            '提醒：',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '無通知',
            style: TextStyle(fontSize: 18),
          ),
        ],
      );
    }
  }

  Widget buildRemark(Event event) {
    return Row(
      children: [
        Icon(Icons.article_outlined),
        const SizedBox(
          width: 3,
        ),
        Text(
          '備註：',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(event.remark.isNotEmpty ? event.remark : '無',
            style: TextStyle(fontSize: 18))
      ],
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) {
    return [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          final editedEvent = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventEditingPage(
                event: _currentEvent,
                addTodayDate: true,
                time: _currentEvent.journeyEndTime,
              ),
            ),
          );

          if (editedEvent != null) {
            setState(() {
              _currentEvent = editedEvent;
            });
          }
          print('顯示事件:');
          print(_currentEvent.journeyName);
          getCalendarDate();
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          Get.defaultDialog(
            title: "提示",
            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            middleText: "是否刪除此行程?",
            middleTextStyle: TextStyle(fontSize: 18),
            backgroundColor: Colors.pinkAccent,
            radius: 30,
            textCancel: "取消",
            cancelTextColor: Colors.white,
            textConfirm: "確認",
            confirmTextColor: Colors.white,
            buttonColor: Colors.blueGrey,
            onCancel: () {
              Navigator.of(context).pop();
            },
            onConfirm: () async {
              final List result = await APIservice.deleteJourney(
                  content: _currentEvent.toMap(), jID: 112);
              print(result[0]);
              if (result[0]) {
                var result = await Sqlite.deleteJourney(
                  tableName: 'journey',
                  tableIdName: 'jid',
                  deleteId: _currentEvent.jID ?? 0,
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/MyBottomBar2',
                  ModalRoute.withName('/'),
                );
              } else {
                print('在server刪除行程失敗');
              }
            },
          );
        },
      ),
    ];
  }
}
