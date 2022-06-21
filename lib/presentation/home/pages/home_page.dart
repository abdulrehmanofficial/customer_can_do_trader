/// lib/presentation/home/pages/home_page.dart
import 'dart:developer';

import 'package:can_do_customer/Screens/order_detail_page.dart';
import 'package:can_do_customer/models/current_user.dart';
import 'package:can_do_customer/models/oders.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomePage extends StatefulWidget {
  String sw = "";
  bool _switchValue = true;

  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => HomePage(),
      );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Orders> orders = [];

  bool isLoading = false;
  int ordersCount = 0;
  double ordersTotal = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
    getCompleteOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _header(context),
              CurrentUser.isOnline == "1"
                  ? Expanded(child: _listView(context))
                  : _offline(context)
            ],
          ),
          isLoading
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : Container(),
        ],
      ),
    );
  }

  // header

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 100,
      color:Theme.of(context).primaryColor ,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "OFFLINE  ",
              style: TextStyle(
                  color: widget._switchValue ? Colors.black : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            CupertinoSwitch(
              value: CurrentUser.isOnline == "1" ? true : false,
              onChanged: (value) {
                setState(() {
                  widget._switchValue = value;
                  CurrentUser.isOnline = value ? "1" : "0";
                  changeOnlineStatus();
                });
              },
            ),
            Text(
              "  ONLINE",
              style: TextStyle(
                  color: widget._switchValue ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  //// ListView

  Widget _listView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _pullRefresh();
      },
      child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(context, index);
          }),
    );
  }

  /// list item

  Widget _item(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    OrderDetailPage(orders[index])));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Customer Info"),
                  IconButton(
                      onPressed: () {
                        var loc = orders[index].customerLocation.split(",");
                        double lat = double.parse(loc[0]);
                        double lng = double.parse(loc[1]);

                        MapsLauncher.launchCoordinates(lat, lng);
                      },
                      icon: Icon(Icons.map))
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(orders[index].image)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                orders[index].firstName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("4.7",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Container(
                              child: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                ignoreGestures: true,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Location"), Text("How Far")],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(orders[index].customerAddress,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "${Constants().calculateDistance(CurrentUser.location!, orders[index].customerLocation)} km",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 55,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),

                    child: TextButton(
                      child: Text(
                        "REJECT",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        rejecttOrder(orders[index].orderId);
                        getOrders();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width / 2 - 55,
                    height: 50,
                    decoration: BoxDecoration(
                        color:Theme.of(context).primaryColor ,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),

                    child: TextButton(
                      child: Text(
                        "ACCEPT",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        acceptOrder(orders[index].orderId);
                        getOrders();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Offline widget

  Widget _offline(BuildContext context) {
    return Container(
        // width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.all(10),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(20),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You are offline nows",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.car_rental,
                            color:Theme.of(context).primaryColor ,
                          ),
                          Text("${ordersCount} Jobs",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.wallet_membership,
                            color:Theme.of(context).primaryColor ,
                          ),
                          Text("${ordersTotal} \$ ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  /// get orders
  void changeOnlineStatus() {
    setState(() {
      isLoading = true;
    });
    ApiRequest()
        .onlineStatusCall(CurrentUser.id!, CurrentUser.isOnline)
        .then((cats) {
      setState(() {
        isLoading = false;
      });
      Constants().saveUserOnlineStatus();
      Constants().showAlert(cats.message);
      if (CurrentUser.isOnline == "1") {
        getOrders();
      }
    });
  }

  /// get orders
  void getOrders() {
    setState(() {
      isLoading = true;
    });
    ApiRequest().getOrdersCall(CurrentUser.id??"0", "0").then((cats) {
      if (cats != null) {
        orders = cats;
        setState(() {});
      } else {
        orders = [];
        Constants().showAlert("No order found.");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  /// accept orders
  void acceptOrder(String id) {
    ApiRequest().acceptOrderCall(id).then((cats) {
      Constants().showAlert(cats.message);
      // getOrders();
    });
  }

  /// reject orders
  void rejecttOrder(String id) {
    ApiRequest().rejectOrderCall(id).then((cats) {
      Constants().showAlert(cats.message);
      // getOrders();
    });
  }

  /// get complete orders
  void getCompleteOrders() {
    ApiRequest().getOrdersCall(CurrentUser.id??"0", "3").then((cats) {
      if (cats != null) {
        double priceTotal = 0;
        for(var i = 0; i < cats.length; i++){
           priceTotal += double.tryParse(cats[i].price)!;
        }

        setState(() {
          ordersCount = cats.length;
          ordersTotal = priceTotal;
        });
      }
    });
  }

  /// pull to refresh

  Future<void> _pullRefresh() async {
    getOrders();
  }
}
