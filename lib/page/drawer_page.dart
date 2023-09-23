// ignore_for_file: camel_case_types, avoid_print

import 'package:flutter/material.dart';

class Drawer_Page extends StatelessWidget {
  const Drawer_Page({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.amber,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'APP 名稱',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
            thickness: 3,
          ),
          ListTile(
            title: const Text(
              '天',
              style: TextStyle(fontSize: 25),
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.calendar_view_day_rounded,
                size: 30,
              ),
            ),
            onTap: () {
              print('天');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              '週',
              style: TextStyle(fontSize: 25),
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.calendar_view_week_rounded,
                size: 30,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              '月',
              style: TextStyle(fontSize: 25),
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.calendar_view_month_rounded,
                size: 30,
              ),
            ),
            onTap: () {},
          ),
          const Divider(
            height: 6,
            color: Colors.grey,
            thickness: 3,
          ),
          ListTile(
            title: const Text('修改個人資料'),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.account_circle_outlined,
                size: 30,
              ),
            ),
            onTap: () {
              print('跳到個人編輯畫面');
            },
          ), //一列一列欄位(每天都event)
          ListTile(
            title: const Text('設定'),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.settings,
                size: 30,
              ),
            ),
            onTap: () {
              print('設定畫面');
            },
          ),
          ListTile(
            title: const Text('登出'),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.logout_outlined,
                size: 30,
              ),
            ),
            onTap: () {
              print('直接登出Google');
            },
          ),
          ListTile(
            title: const Text('說明'),
            leading: const CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.help_outline_sharp,
                size: 30,
              ),
            ),
            onTap: () {
              print('跳出說明APP資訊');
            },
          )
        ],
      ),
    );
  }
}
