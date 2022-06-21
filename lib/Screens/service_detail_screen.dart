import 'package:can_do_customer/Screens/google_place.dart';
import 'package:can_do_customer/models/address.dart';
import 'package:can_do_customer/models/category.dart';
import 'package:can_do_customer/models/current_user.dart';
import 'package:can_do_customer/models/myservices.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:can_do_customer/models/user.dart';

class ServiceDetailPage extends StatefulWidget {
  // bool isEdit;
  MyServices service;
  ServiceDetailPage(this.service, {Key? key}) : super(key: key);

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<ServiceDetailPage> {
  String userId = "", subCatId = "", catId = "", latlng = "", price = "";
  String? currLat, currLng;
  Address? currLocation;
  User? userData;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isLoading = false;

  String dropdownValue = "Select Category";
  String? subDropdownValue = "Select SubCategory";

  List<Categories> allCats = [];
  List<Subcategory> subCats = [];

  List<String> mainCat = ["Select Category"];
  List<String> subCat = ["Select SubCategory"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setData();
    // getCats();
    // getCurrLatLng();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Service Details"),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Center(
          child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),

              // _actionSheet(context),
              _form(context),
              // _signUp(context),
            ],
          ),
        ],
      )),
    );
  }

  /// Form

  Widget _form(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            width: 320,
            // height: 50,
            //padding: EdgeInsetsDirectional.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Main Category: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.service.categoryName!,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            // Container(
            //   width: 320,
            //   height: 50,
            //   child:   DropdownButton(
            //     isExpanded: true,
            //     isDense: true,
            //     items: mainCat
            //         .map((String item) => DropdownMenuItem<String>(
            //             child: Text(item), value: item))
            //         .toList(),
            //     onChanged: (String? value) {
            //       setState(() {
            //         // print("previous ${this._salutation}");
            //         print("selected $value");
            //         dropdownValue = value ?? "";
            //         setSubCat();
            //       });
            //     },
            //     value: dropdownValue,
            //   ),
            // ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            //padding: EdgeInsetsDirectional.only(top: 10),
            child: Container(
              width: 320,
              // height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sub Category: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.service.subcategories.first.subcategoryName,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              //  DropdownButton(
              //   isExpanded: true,
              //   items: subCat
              //       .map((String item) => DropdownMenuItem<String>(
              //           child: Text(item), value: item))
              //       .toList(),
              //   onChanged: (String? value) {
              //     setState(() {
              //       // print("previous ${this._salutation}");
              //       print("sub selected $value");
              //       subDropdownValue = value ?? "";
              //       getSubCatId();
              //     });
              //   },
              //   value: subDropdownValue,
              // ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
              width: 320,
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Starting Price: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("\$ ${(widget.service.startingPrice)}",
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Location:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              )
              // TextFormField(
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   validator: (input) {
              //     if (input!.isEmpty) {
              //       return ' Please enter an email';
              //     }
              //   },
              //   initialValue: price,
              //   onSaved: (input) => price = input!,
              //   onEditingComplete: () {},
              //   decoration: InputDecoration(labelText: "Price"),
              // ),
              ),

          Container(
              width: 350,
              //height: 60,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              padding: EdgeInsetsDirectional.only(top: 10),
              decoration: BoxDecoration(
                  //color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)),
              child: GestureDetector(
                  onTap: () {
                    //goToSecondScreen(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             GooglePlace(currLocation!)));
                  },
                  child: currLocation?.lat == null
                      ? Container(
                          // alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 30, top: 10),
                          child: Text("Please select service location"))
                      : Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Lat:",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(" ${currLocation!.lat} "),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Lng:",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(" ${currLocation!.lng} "),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Address: ${currLocation!.address ?? ""}"),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ))),
          // isLoading == false
          //     ? Container(
          //         width: MediaQuery.of(context).size.width - 70,
          //         height: 50,
          //          style: ElevatedButton.styleFrom(

          //         margin: const EdgeInsetsDirectional.only(top: 30),
          //         child: ElevatedButton(
          //           onPressed: () {
          //             final _formState = _globalKey.currentState;

          //             if (_formState!.validate()) {
          //               _formState.save();
          //               // if (loginType == "kitchen") {

          //               if (isValid()) {
          //                 addService();
          //               }
          //             }
          //           },
          //            style: ElevatedButton.styleFrom(

          //           child: Text(
          //             "Add",
          //             style: TextStyle(color: Colors.white),
          //           ),
          //         ),
          //       )
          //     : CircularProgressIndicator()
        ],
      ),
    );
  }

  void getCurrLatLng() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    currLat = sharedUser.getString('lat');
    currLng = sharedUser.getString('lng');
    currLocation = Address(currLat, currLat);
    //User user = sharedUser.get("user");
    print("location saved");
  }

  void getCats() {
    ApiRequest().getCategory().then((cats) {
      if (cats != null) {
        allCats = cats;
        cats.forEach((element) {
          mainCat.add(element.categoryName);
        });
        // setData();
        setState(() {});
      } else {
        Constants().showAlert("No Category found.");
      }
    });
  }

  void setSubCat() {
    for (var element in allCats) {
      catId = element.categoryId;
      if (element.categoryName == dropdownValue) {
        subCats = element.subcategories;
        for (var sub in element.subcategories) {
          subCat.add(sub.subcategoryName);
        }
      }
    }
  }

  void getSubCatId() {
    for (var element in subCats) {
      if (element.subcategoryName == subDropdownValue) {
        subCatId = element.subcategoryId;
      }
    }
  }

  void goToSecondScreen(BuildContext context) async {
    Address dataFromSecondPage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GooglePlace(currLocation!),
        ));
    setState(() {
      currLocation = dataFromSecondPage;
    });
  }

  void setData() {
    final latlng = CurrentUser.location!.split(",");
    currLocation = Address(latlng[0], latlng[1]);
    userId = CurrentUser.id ?? "";
  }
}
