import 'package:can_do_customer/Screens/google_place.dart';
import 'package:can_do_customer/models/address.dart';
import 'package:can_do_customer/models/category.dart';
import 'package:can_do_customer/models/myservices.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:can_do_customer/models/user.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddServicePage extends StatefulWidget {
  bool isEdit;
  MyServices? service;
  AddServicePage(this.isEdit, this.service);

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  String userId = "",
      subCatId = "",
      catId = "",
      latlng = "",
      price = "",
      serviceId = "";
  String? currLat, currLng;
  Address? currLocation;
  User? userData;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  bool isLoading = false;

  String dropdownValue = "Select Category";
  String? subDropdownValue = "Select SubCategory";

  List<Categories> allCats = [];
  List<Subcategory>? subCats;

  List<String> mainCat = ["Select Category"];
  List<Map<String, dynamic>> subCatDic = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEdit) {
      serviceId = widget.service!.serviceId!;
      setData();
    } else {
      getCurrLatLng();
    }
    getCats();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Service"),
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
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            //padding: EdgeInsetsDirectional.only(top: 10),
            child: Container(
              width: 320,
              height: 50,
              child: DropdownButton(
                isExpanded: true,
                isDense: true,
                items: mainCat
                    .map((String item) => DropdownMenuItem<String>(
                        child: Text(item), value: item))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    // print("previous ${this._salutation}");
                    print("selected $value");
                    dropdownValue = value ?? "";
                    setSubCat();
                  });
                },
                value: dropdownValue,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            //padding: EdgeInsetsDirectional.only(top: 10),
            child: Container(
              width: 320,
              //height: 50,
              child: subCatDic.isEmpty
                  ? Container()
                  : MultiSelect(
                      //autovalidate: false,
                      titleText: "Sub Categories",
                      maxLength: 10,
                      maxLengthIndicatorColor: Colors.white,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select one or more option(s)';
                        }
                      },
                      errorText: 'Please select one or more option(s)',
                      dataSource: subCatDic,
                      textField: 'name',
                      valueField: 'code',
                      filterable: true,
                      required: true,
                      //value: null,
                      onSaved: (dynamic value) {
                        print('The saved values are $value');
                        List<dynamic> arr = value;
                        var j = arr.join(",");
                        subCatId = j;
                      }),
            ),
          ),
          Container(
            height: 70,
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            padding: EdgeInsetsDirectional.only(top: 10),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an email';
                }
              },
              initialValue: price,
              onSaved: (input) => price = input!,
              onEditingComplete: () {},
              decoration: InputDecoration(
                  labelText: "Starting Price (\$)",
                  hintStyle: TextStyle(fontSize: 18)),
            ),
          ),
          Container(
            width: 350,
            // height: 60,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            padding: EdgeInsetsDirectional.only(top: 10),
            child: Text("Address"),
          ),
          Container(
              width: 350,
              height: 150,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              padding: EdgeInsetsDirectional.only(top: 10),
              decoration: BoxDecoration(
                  //color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey)),
              child: GestureDetector(
                  onTap: () {
                   // goToSecondScreen(context);
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
                              Row(children: [
                                ElevatedButton(
                                  onPressed: () {
                                    goToSecondScreen(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,),
                                  child: Text(
                                    "Add Location",
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                )
                              ],),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Address: ${currLocation!.address ?? ""}")
                            ],
                          ),
                        ))),
          isLoading == false
              ? Container(
                  width: MediaQuery.of(context).size.width - 70,
                  height: 50,
                   color:Theme.of(context).primaryColor ,

                  margin: const EdgeInsetsDirectional.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      final _formState = _globalKey.currentState;

                      if (_formState!.validate()) {
                        _formState.save();
                        // if (loginType == "kitchen") {

                        if (isValid()) {
                          if (widget.isEdit) {
                            editService();
                          } else {
                            addService();
                          }
                        } else {
                          Constants().showAlert("Please enter all fields");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,),
                    child: Text(
                      widget.isEdit ? "Update" : "Add",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              : CircularProgressIndicator()
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
      if (cats!.isNotEmpty) {
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

  // void _showMultiSelect(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return MultiSelectDialog(
  //         items: _items,
  //         initialValue: _selectedAnimals,
  //         onConfirm: (values) {},
  //       );
  //     },
  //   );
  // }

  void setSubCat() {
    for (var element in allCats) {
      if (element.categoryName == dropdownValue) {
        catId = element.categoryId;
        subCats = element.subcategories;
        subCatDic.clear();
        for (var sub in element.subcategories) {
          //subCat.add(sub.subcategoryName);
          var dic = {"name": sub.subcategoryName, "code": sub.subcategoryId};
          subCatDic.add(dic);
        }
      }
    }
    setState(() {});
  }

  void getSubCatId() {
    for (var element in subCats!) {
      if (element.subcategoryName == subDropdownValue) {
        subCatId = element.subcategoryId;
      }
    }
  }

  void addService() {
    String latlng = "${currLocation!.lat},${currLocation!.lng}";
    ApiRequest()
        .addSeriveCall(userId, catId, subCatId, latlng, price)
        .then((cats) {
      // if (cats.status == "true") {

      // } else {
      Constants().showAlert(cats.message);
      Navigator.pop(context);
      // }

      setState(() {
        isLoading = false;
      });
    });
  }

  // edit Service
  void editService() {
    String latlng = "${currLocation!.lat},${currLocation!.lng}";
    ApiRequest()
        .editSeriveCall(userId, catId, subCatId, latlng, price, serviceId)
        .then((cats) {
      // if (cats.status == "true") {

      // } else {
      Constants().showAlert(cats.message);
      // Navigator.pop(context);
      // }

      setState(() {
        isLoading = false;
      });
    });
  }

  bool isValid() {
    if (catId != "" && subCatId != "" && currLocation != null && price != "") {
      setState(() {
        isLoading = true;
      });
      return true;
    }
    return false;
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

  void getData() async {
    var user = await Constants().getUserData();
    if (user != null) {
      print(user);
      setState(() {
        userData = user;
        userId = user.id ?? "";
      });
    }
  }

  void setData() {
    if (widget.isEdit) {
      price = widget.service!.startingPrice!;
      final latlng = widget.service!.latlong!.split(",");
      currLocation = Address(latlng[0], latlng[1]);
      setState(() {});
    }
  }
}
