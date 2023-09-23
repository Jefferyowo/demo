// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

//import 'package:create_event2/model/event.dart';
import 'package:create_event2/model/event.dart';
import 'package:create_event2/model/event_data_source.dart';
import 'package:create_event2/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:create_event2/page/event_viewing_page.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    // final selectedEvents = provider.eventOfSelectedDate;
    /*
    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          'No Event Found!',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    } else {*/
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      child: SfCalendar(
        showCurrentTimeIndicator: false,
        view: CalendarView.schedule,
        scheduleViewSettings: ScheduleViewSettings(
          appointmentItemHeight: 50,
          //hideEmptyScheduleWeek: true,
          dayHeaderSettings: DayHeaderSettings(
            dayFormat: 'EEEE',
            width: 70,
            dayTextStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            dateTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ),
        dataSource: EventDateSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        onTap: (details) {
          if (details.appointments == null) return;
          final event = details.appointments!.first;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventViewingPage(event: event),
            ),
          );
        },
      ),
    );
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        if (event.isAllDay)
          Text(
            '全天',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        if (!event.isAllDay) buildDate('起始時間：', event.journeyStartTime),
        if (!event.isAllDay) buildDate('結束時間：', event.journeyEndTime),
      ],
    );
  }

  Widget buildDate(String date, DateTime dateTime) {
    final dateString = DateFormat.jm().format(dateTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          date,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(dateString, style: TextStyle(fontSize: 10, color: Colors.white))
      ],
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first as Event;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              event.journeyName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          buildDateTime(event)
        ],
      ),
    );
  }
}
