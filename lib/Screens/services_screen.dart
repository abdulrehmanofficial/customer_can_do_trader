import 'package:can_do_customer/Screens/addservice_page.dart';
import 'package:can_do_customer/Screens/service_detail_screen.dart';
import 'package:can_do_customer/models/myservices.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  String userId;
  ServicesPage(this.userId, {Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<ServicesPage> {
  List<MyServices> cats = [];
  // RandomColor _randomColor = RandomColor();
  //final Random _random = Random();

  bool isLoading = false;
  String userID="0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userID=widget.userId;
    getService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Services')),
          //backgroundColor: Colors.amberAccent,
          //leading: Icon(Icons.gps_fixed),
          actions: [
            TextButton(
                onPressed: () {
                  // googleAutoComplete();
                  //showAlertDialog(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddServicePage(false, null)));
                },
                child: const Text(
                  'AddService',
                  style: TextStyle(
                      fontFamily: 'Futura', fontSize: 20, color: Colors.white),
                )),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [_categoryListView(context)],
            ),
            isLoading
                ? Container(
                    child: const Center(
                    child: CircularProgressIndicator(),
                  ))
                : Container(),
          ],
        ));
  }

//// listview
  Widget _categoryListView(BuildContext context) {
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        _pullRefresh();
      },
      child: ListView.builder(
          itemCount: cats.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ServiceDetailPage(cats[index])));
                },
                child: _header(context, index));
          }),
    ));
  }
  // header

  Widget _header(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
      // height: 110,
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                cats[index].categoryName!,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    cats[index].subcategories.first.subcategoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
            ),
            const SizedBox(height: 5),
            Container(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$" + cats[index].startingPrice!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AddServicePage(true, cats[index])));
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteService(cats[index].serviceId!);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// pull to refresh

  Future<void> _pullRefresh() async {
    getService();
  }

  // gets Services
  void getService() {
    setState(() {
      isLoading = true;
    });
    cats.clear();
    ApiRequest().getMySeriveCall(userID).then((reg) {
      if (cats != null) {
        cats = reg!;
      } else {
        Constants().showAlert("No service found.");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  //
  void deleteService(String id) {
    Constants().showAlert("Please wait...");
    ApiRequest().deleteServiceCall(id).then((reg) {
      Constants().showAlert(reg.message);
      getService();
    });
  }
}
