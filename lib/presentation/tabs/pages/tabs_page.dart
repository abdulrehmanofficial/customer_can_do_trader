import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/material.dart';
import 'package:can_do_customer/presentation/tabs/models/tab_navigation_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../payment_service.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    update();
    super.initState();
  }

  update() async {
    var user = await Constants().getUserData();
    Constants().updatePlayerId(user?.id??"0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: <BottomNavigationBarItem>[
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title.toString(),
            ),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
