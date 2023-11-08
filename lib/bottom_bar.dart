// ignore_for_file: prefer_const_constructors

import 'package:create_event2/page/chat_room_page.dart';
import 'package:flutter/material.dart';
import 'package:create_event2/main.dart';
import 'package:create_event2/page/event_editing_page.dart';
import 'package:create_event2/page/search_page.dart';

import 'model/vote.dart';

class MyBottomBar extends StatefulWidget {
  final int i; // 點選哪個buttom

  const MyBottomBar({
    Key? key,
    required this.i,
  }) : super(key: key);

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 2;
  bool _showBottomNavBar = true;

  Vote? someVote;  // Declare a nullable Vote variable
  
  static get _currentVote => null;

// Check if someVote is not null before using it
// if (someVote != null) {
//   // Use someVote
//   // Example: print(someVote.property); 
// } else {
//   // Handle the case where someVote is null
// }


  final List<Widget> _screens = [
    ChatRoomPage(), //0
    EventEditingPage(
      addTodayDate: false,
      time: DateTime.now(),
    ), //1
    MainPage(), //2
    SearchPage(), //3
    Friend() //4
  ];
  
  
  
  
  // 點選buttom
  void _onItemTapped(int idx) {
    setState(() {
      _selectedIndex = idx;

      _showBottomNavBar = (_selectedIndex != 1); // 更新 _showBottomNavBar
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.i; // 設初始值
    _showBottomNavBar = (_selectedIndex != 1); // 根據初始值設 _showBottomNavBar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _showBottomNavBar
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedLabelStyle: const TextStyle(fontSize: 18),
              unselectedLabelStyle: const TextStyle(fontSize: 18),
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.calendar_today_rounded,
                    ),
                    label: '活動',
                    backgroundColor: Colors.red),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add,
                    ),
                    label: '新增行程',
                    backgroundColor: Colors.blue),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: '主畫面',
                    backgroundColor: Colors.purpleAccent),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search_rounded,
                    ),
                    label: '搜尋',
                    backgroundColor: Colors.yellow),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.people,
                    ),
                    label: '好友',
                    backgroundColor: Colors.green),
              ],
            )
          : null,
    );
  }
}
