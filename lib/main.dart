// import 'dart:io';
// import 'package:create_event2/model/event.dart';
// import 'package:create_event2/page/event_viewing_page.dart';
// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:create_event2/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:create_event2/model/event_data_source.dart';
import 'package:create_event2/page/drawer_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:create_event2/bottom_bar.dart';
import 'package:create_event2/page/selectday_viewing_page.dart';
import 'package:create_event2/services/sqlite.dart';
import 'package:create_event2/model/event.dart';
import 'package:create_event2/services/http.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = '好揪不見';

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => EventProvider(),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale.fromSubtags(
                languageCode: 'zh',
                scriptCode: 'Hant'), // generic traditional Chinese 'zh_Hant'
            Locale('en', 'US'),
            Locale.fromSubtags(
                languageCode: 'zh',
                scriptCode: 'Hant',
                countryCode: 'TW'), // 'zh_Hant_TW'
          ],
          locale: Locale('zh'),
          routes: {
            '/MyBottomBar0': ((context) => const MyBottomBar(
                  i: 0,
                )),
            '/MyBottomBar1': ((context) => const MyBottomBar(
                  i: 1,
                )),
            '/MyBottomBar2': ((context) => const MyBottomBar(
                  i: 2,
                )),
            '/MyBottomBar3': ((context) => const MyBottomBar(
                  i: 3,
                )),
            '/MyBottomBar4': ((context) => const MyBottomBar(
                  i: 4,
                )),
          },
          title: title,
          themeMode: ThemeMode.light,
          darkTheme:
              ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
          home: LoginPage(),
        ),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 顯示行事曆方式controller
  final CalendarController _controller = CalendarController();
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
    // 從server抓使用者行事曆資料
    var userID = {'uid': '5533'};
    final result = await APIservice.selectAll(content: userID, uID: '5533');
    print(result);
    await Sqlite.open; //開啟資料庫
    List? queryCalendarTable = await Sqlite.queryAll(tableName: 'journey');
    queryCalendarTable ??= [];
    setState(() {
      eventTest = queryCalendarTable!.map((e) => Event.fromMap(e)).toList();
    });
    // for (var element in queryCalendarTable) {
    //   print(element);
    // }
    print(eventTest);
    return queryCalendarTable;
  }

  @override
  Widget build(BuildContext context) {
    //final events = Provider.of<EventProvider>(context).events;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        endDrawer: Drawer_Page(),
        appBar: AppBar(
          title: const Text('行事曆'),
          centerTitle: true,
        ),
        body: SfCalendar(
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
          ],
          controller: _controller,
          showDatePickerButton: true,
          headerStyle: CalendarHeaderStyle(textStyle: TextStyle(fontSize: 25)),
          view: CalendarView.month,
          dataSource: EventDateSource(eventTest),
          cellEndPadding: 5,
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          initialSelectedDate: DateTime.now(),
          cellBorderColor: Colors.transparent,
          onTap: (details) {
            final provider = Provider.of<EventProvider>(context, listen: false);
            provider.setDate(details.date!);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SelectedDayViewingPage()),
            );
            // showModalBottomSheet(
            //     context: context, builder: (context) => const TaskWidget());
          },
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '登入',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyBottomBar(i: 2),
                ),
              );
            },
            icon: Icon(Icons.login),
          ),
        ),
      ),
    );
  }
}

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Activity'),
    );
  }
}

class Friend extends StatelessWidget {
  const Friend({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Friend'),
    );
  }
}
