import 'package:can_do_customer/Screens/services_screen.dart';
import 'package:can_do_customer/models/current_user.dart';
import 'package:can_do_customer/presentation/product_detail/pages/product_detail_page.dart';
import 'package:can_do_customer/presentation/profile_page.dart/profile_page.dart';
import 'package:can_do_customer/presentation/profile_page.dart/tasklist_page.dart';
import 'package:can_do_customer/presentation/rating/pages/rating_page.dart';
import 'package:flutter/material.dart';
import 'package:can_do_customer/presentation/home/pages/home_page.dart';
import 'package:can_do_customer/presentation/search/pages/earning_page.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomePage(),
          icon: Icon(Icons.home),
          title: 'Home',
        ),
        TabNavigationItem(
          page: ServicesPage(CurrentUser.id??"0"),
          icon: Icon(Icons.settings),
          title: "Services",
        ),
        TabNavigationItem(
          page: TaskListPage(),
          icon: Icon(Icons.bookmark),
          title: 'Tasks',
        ),
        TabNavigationItem(
          page: ProfilePage(),
          icon: Icon(Icons.person),
          title: 'Profile',
        ),
      ];
}
