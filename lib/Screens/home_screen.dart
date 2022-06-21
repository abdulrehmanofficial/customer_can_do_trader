import 'package:can_do_customer/Screens/registrantion_screen.dart';
import 'package:can_do_customer/models/current_user.dart';
import 'package:can_do_customer/models/oders.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userId = "";
  int _selectedIndex = 0;

  List<Orders> orders = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _switchValue = false;

    return Scaffold(
      body: Container(
          child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            height: 100,
            color:Theme.of(context).primaryColor ,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "OFFLINE",
                    style: TextStyle(
                        color:
                            _switchValue == true ? Colors.black : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  FlutterSwitch(
                    width: 100.0,
                    height: 30.0,
                    valueFontSize: 25.0,
                    toggleSize: 25.0,
                    value: _switchValue,
                    borderRadius: 30.0,
                    padding: 8.0,
                    //showOnOff: true,

                    onToggle: (val) {
                      print("changed");
                      setState(() {
                        _switchValue = val;
                        changeStatus(val ? "1" : "0");
                      });
                    },
                  ),
                  Text(
                    "ONLINE",
                    style: TextStyle(
                        color:
                            _switchValue == false ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 100),
              child: _widgetOptions.elementAt(_selectedIndex)),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Earning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  void changeStatus(String status) {
    ApiRequest().onlineStatusCall(userId, status).then((cats) {
      Constants().showAlert(cats.message);
      //setState(() {});
    });
  }

  void getData() async {
    userId = CurrentUser.id ?? "";
  }
}
