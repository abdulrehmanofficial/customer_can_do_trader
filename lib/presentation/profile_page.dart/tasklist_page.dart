import 'package:can_do_customer/Screens/order_detail_page.dart';
import 'package:can_do_customer/models/current_user.dart';
import 'package:can_do_customer/models/oders.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _textFieldController = TextEditingController();

  List<Orders> completeOrders = [];
  List<Orders> inProgressOrders = [];
  List<Orders> orders = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    getCompleteOrders();
    getinProgresOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "COMPLETED",
                ),
                Tab(
                  text: "IN-PROGRESS",
                ),
              ],
              // onTap: (),
            ),
            title: const Text('My Tasks'),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  _completeView(context, completeOrders, 0),
                  _completeView(context, inProgressOrders, 1),
                  // Icon(Icons.directions_bike),
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
        ),
      ),
    );
  }

  Widget _completeView(BuildContext context, List<Orders> _orders, int type) {
    return RefreshIndicator(
      onRefresh: () async {
        _pullRefresh(type);
      },
      child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(context, _orders, index, type);
          }),
    );
  }

  Widget _item(
      BuildContext context, List<Orders> _orders, int index, int type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    OrderDetailPage(_orders[index])));
      },
      child: Container(
        // width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.all(10),
        //  height: 160,
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
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    // margin: EdgeInsets.only(left: 20),
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(_orders[index].image)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    //color: Colors.red,
                    width: MediaQuery.of(context).size.width - 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _orders[index].firstName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text("\$${_orders[index].price}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_orders[index].categoryName),
                              IconButton(
                                  onPressed: () {
                                    // MapsLauncher.launchCoordinates(
                                    //   37.4220041, -122.0862462);
                                  },
                                  icon: Icon(Icons.map))
                            ],
                          ),
                        ),
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
                  children: [
                    Container(
                      height: 20,
                      width: 20,

                      // style: ElevatedButton.styleFrom(

                      decoration: BoxDecoration(
                        color:Theme.of(context).primaryColor ,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(_orders[index].customerAddress,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,

                            // style: ElevatedButton.styleFrom(
                            // color:Theme.of(context).primaryColor ,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                              "${Constants().calculateDistance(CurrentUser.location??"0.0", _orders[index].customerLocation)} km",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _button(context, type, _orders, index),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(
      BuildContext context, int type, List<Orders> _orders, int index) {
    switch (type) {
      case 3:
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          // color:Theme.of(context).primaryColor ,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),

          child: TextButton(
            child: const Text(
              "Pending",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              print("Complete");

              //markCompleteOrder(_orders[index].orderId);
              //_displayTextInputDialog(context, _orders[index].orderId);
            },
          ),
        );

      case 1:
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          // color:Theme.of(context).primaryColor ,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),

          child: TextButton(
            child: const Text(
              "Mark Complete",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              print("Complete");

              //markCompleteOrder(_orders[index].orderId);
              _displayTextInputDialog(context, _orders[index].orderId);
            },
          ),
        );
      case 0:
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          // color:Theme.of(context).primaryColor ,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),

          child: TextButton(
            child: const Text(
              "Completed",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print("Completed");

              //markCompleteOrder(_orders[index].orderId);
              // _displayTextInputDialog(context, _orders[index].orderId);
            },
          ),
        );
    }
    return Text("");
  }

  Future<void> _displayTextInputDialog(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Please enter total payment'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Price"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                print(_textFieldController.text);
                if (_textFieldController.text != "") {
                  markCompleteOrder(id, _textFieldController.text);
                  Navigator.pop(context);
                } else {
                  Constants().showAlert("Please enter price");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void markCompleteOrder(String id, String price) {
    setState(() {
      isLoading = true;
    });
    ApiRequest().completeOrderCall(id, price).then((cats) {
      Constants().showAlert(cats.message);
      getCompleteOrders();
      getinProgresOrders();
      setState(() {
        isLoading = false;
      });
    });
  }

  /// get complete orders
  void getCompleteOrders() {
    setState(() {
      isLoading = true;
    });
    completeOrders.clear();
    ApiRequest().getOrdersCall(CurrentUser.id??"0", "3").then((cats) {
      if (cats != null) {
        completeOrders = cats;
        setState(() {});
      } else {
        Constants().showAlert("No order found.");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  /// get inprogress orders

  void getinProgresOrders() {
    setState(() {
      isLoading = true;
    });
    inProgressOrders.clear();
    ApiRequest().getOrdersCall(CurrentUser.id!, "1").then((cats) {
      if (cats != null) {
        inProgressOrders = cats;
        setState(() {});
      } else {
        Constants().showAlert("No order found.");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  // tab listner
  void _setActiveTabIndex() {
    int index = _tabController.index;
    switch (index) {
      case 0:
        setState(() {
          orders = completeOrders;
        });
        break;
      case 1:
        setState(() {
          orders = inProgressOrders;
        });
        break;
    }
  }

  /// pull to refresh

  Future<void> _pullRefresh(int type) async {
    if (type == 0) {
      getCompleteOrders();
    } else if (type == 1) {
      getinProgresOrders();
    } else {
      getCompleteOrders();
    }
  }
}
