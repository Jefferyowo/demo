// ignore_for_file: unused_import, avoid_print

import 'package:create_event2/model/event.dart';
import 'package:create_event2/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:create_event2/services/sqlite.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventOfSelectedDate => _events;

  Future<void> fetchEventsFromDatabase() async {
    final List<Map<String, dynamic>>? queryResult =
        await Sqlite.queryAll(tableName: 'journey');
    _events.clear();
    _events.addAll(queryResult!.map((e) => Event.fromMap(e)));
    print('有拿到數據');
    notifyListeners();
  }

  // void addEvent(Event event) {
  //   _events.add(event);
  //   notifyListeners();
  // }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  // void editEvent(Event newEvent, Event oldEvent) {
  //   final index = _events.indexOf(oldEvent);
  //   if (index != -1) {
  //     _events[index] = newEvent;
  //     notifyListeners();
  //   } else {
  //     // 找不到 oldEvent，進行錯誤處理
  //     print('找不到要編輯的事件！');
  //   }
  // }

  // List<Event> searchEvents(String keyword) {
  //   return _events
  //       .where((event) =>
  //           event.title.toLowerCase().contains(keyword.toLowerCase()))
  //       .toList();
  // }

  List<Event> getEvents() {
    return List.from(_events);
  }

  void updateEvents(List<Event> updatedEvents) {
    _events.clear();
    _events.addAll(updatedEvents);
    notifyListeners();
  }
}
