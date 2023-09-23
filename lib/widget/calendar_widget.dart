// ignore_for_file: avoid_print

import 'package:create_event2/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:create_event2/model/event_data_source.dart';
import 'package:create_event2/page/selectday_viewing_page.dart';
import 'package:create_event2/services/sqlite.dart';
import 'package:create_event2/model/event.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<Event> eventTest = [];

  @override
  void initState() {
    getCalendarDate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCalendarDate() async {
    //await Sqlite.dropDatabase();
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable = await Sqlite.queryAll(tableName: 'journey');
    queryCalendarTable ??= [];
    eventTest = queryCalendarTable.map((e) => Event.fromMap(e)).toList();
    print(eventTest[1]);
    return queryCalendarTable;
  }

  @override
  Widget build(BuildContext context) {
    //final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDateSource(eventTest),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onTap: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const SelectedDayViewingPage()),
        );
        // showModalBottomSheet(
        //     context: context, builder: (context) => const TaskWidget());
      },
    );
  }
}
