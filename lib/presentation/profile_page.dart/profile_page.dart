import 'dart:developer';
import 'dart:io';

import 'package:can_do_customer/Screens/addservice_page.dart';
import 'package:can_do_customer/Screens/changepass_page.dart';
import 'package:can_do_customer/Screens/edit_profile.dart';
import 'package:can_do_customer/Screens/google_place.dart';
import 'package:can_do_customer/Screens/login_screen.dart';
import 'package:can_do_customer/Screens/services_screen.dart';
import 'package:can_do_customer/flutter_purchase.dart';
import 'package:can_do_customer/flutter_purchase.dart';
import 'package:can_do_customer/models/user.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:can_do_customer/payment_service.dart';
import 'package:can_do_customer/presentation/profile_page.dart/earning_page.dart';
import 'package:can_do_customer/presentation/profile_page.dart/profile_detail.dart';
import 'package:can_do_customer/presentation/profile_page.dart/tasklist_page.dart';
import 'package:can_do_customer/presentation/profile_page.dart/term_condition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

const kGoogleApiKey = "AIzaSyCkhCz2qsYBgy9pNoSh0ccjzUD5flu49qI";
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class ProfilePage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => ProfilePage(),
      );

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? userDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        // leading: Text(""),
        // actions: [
        //   FlatButton(
        //       onPressed: () {},
        //       child: TextButton(
        //         child: Text(
        //           'Logout',
        //           style: TextStyle(fontSize: 18, color: Colors.white),
        //         ),
        //         onPressed: () {
        //           showAlertDialog(context);
        //         },
        //       )),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            Text("You are already subscribed"),
            ElevatedButton(
              onPressed: () async {
                try{
                      List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(['candotrader.trader.subscription']);
                      print(items[0].productId!);

                      PurchasedItem item = await FlutterInappPurchase.instance.requestPurchase(items[0].productId!);
                      await FlutterInappPurchase.instance.finishTransaction(item);

                      var user = await Constants().getUserData();
                      ApiRequest().addSubscription(user?.id??"0");
                }
                catch(e,stackTrace){
                  // log(e.toString());
                  // log(stackTrace.toString());
                  print(e.toString());
                }

                // log(PaymentService.instance.products.length.toString());
              /*  final _formState = _globalKey.currentState;

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
                }*/
              },
               style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,),
              child: Text(
                "Buy Subscription",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new TaskListPage()));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Orders',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.80)),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color:Theme.of(context).primaryColor ,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
              ),
            ),
            SizedBox(height: 16,),
            InkWell(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new TaskListPage()));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    orderSingleItem(Icons.pending, "Pending"),
                    orderSingleItem(Icons.pending, "InProgress"),
                    orderSingleItem(Icons.pending, "Complete"),
                    orderSingleItem(Icons.cancel, "Canceled")
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,bottom: 16),
              child: Divider(
                height: 2,
                thickness: 2.5,
              ),
            ),
            Column(
              children: [
                detailSingleItem(Icons.supervised_user_circle,'Edit Profile',(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EditProfile(userDate)),
                  );
                }),
                detailSingleItem(Icons.password,'Change Password',(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ChangePassPage(userDate?.email??"")),
                  );
                }),
                detailSingleItem(Icons.share,'Invite Friends',() async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  String packageName = packageInfo.packageName;

                  Share.share(
                      'check out Can Do Today app here: https://play.google.com/store/apps/details?id=' +
                          packageName,
                      subject: 'Can Do Today App');
                }),
                detailSingleItem(Icons.settings,'Services',(){
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new ServicesPage(userDate?.id ?? "")));
                }),

            /*    detailSingleItem(Icons.settings,'Testing',(){
                  PaymentService.instance.initialize();
                  log(PaymentService.instance.products.length.toString());
                }),*/
                detailSingleItem(Icons.bookmark,'Tasks',(){
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new TaskListPage()));
                }),
                detailSingleItem(Icons.star,'Rate',(){
               /*   final InAppReview inAppReview = InAppReview.instance;

                  inAppReview.isAvailable().then((value) {
                    if(value){
                      inAppReview.requestReview();
                    }
                    else{
                      Constants().showAlert("Rate Option Not Available");
                    }
                  });*/

                  LaunchReview.launch();
                }),
                detailSingleItem(Icons.contact_support,'About Us',(){
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new TermsConditionPage()));
                }),
                detailSingleItem(Icons.logout,'Log Out',(){showAlertDialog(context);}),
              ],
            ),
           /* Row(children: [
              _services(context),_task(context)
            ],),
            Row(children: [
              _services(context),_task(context)
            ],)*/
          ],
        ),
      ),
    );
  }

  Widget orderSingleItem(IconData icon, String title) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration( color:Theme.of(context).primaryColor , borderRadius: BorderRadius.circular(5)),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
        )
      ],
    );
  }

  Widget detailSingleItem(IconData iconData,String title,Function ontap){
    return InkWell(
      onTap: (){
        ontap();
      },
      child: Padding(
        padding:  EdgeInsets.only(left: 16,right: 16,top: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(children: [
                Icon(iconData),
                SizedBox(width: 10,),
                Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.80)),)
              ],),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color:Theme.of(context).primaryColor ,
              )

            ],),
            SizedBox(height: 10,),
            Divider(
              height: 1,
              thickness: 1
            )
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Container(
            // margin: EdgeInsets.only(left: 20),
            width: 60,
            height: 60,
            child: userDate == null || userDate?.image == null
                ? Image.asset("assets/images/aclogo.png")
                : CircleAvatar(
                    backgroundImage: NetworkImage(userDate!.image!),
                    // onBackgroundImageError: (context, url, error) => new Icon(Icons.error),
                    onBackgroundImageError: (obj, err) {
                      print(err);
                    },
                  ),
            //child: Image.file(File(_profileImage!.path)),
          ),
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                " ${userDate?.firstName ?? ""}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    "View Profile",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new ProfileDetailPage()));
                  },
                ),
              )
            ],
          ),
          subtitle: Row(
            children: [
              Text(userDate?.mobile ?? "n/a", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );

    return Container(
      //margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
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
        margin: EdgeInsets.only(left: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  // margin: EdgeInsets.only(left: 20),
                  width: 60,
                  height: 60,
                  child: userDate == null || userDate?.image == null
                      ? Image.asset("assets/images/aclogo.png")
                      : CircleAvatar(
                          backgroundImage: NetworkImage(userDate!.image!),
                          // onBackgroundImageError: (context, url, error) => new Icon(Icons.error),
                          onBackgroundImageError: (obj, err) {
                            print(err);
                          },
                        ),
                  //child: Image.file(File(_profileImage!.path)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.red,
                        // margin: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              " ${userDate?.firstName ?? ""} ${userDate?.lastName ?? ""}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text(
                                  "View Profile",
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                                onPressed: () {
                                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new ProfileDetailPage()));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Row(
                        children: [
                          Text(userDate?.mobile ?? "n/a", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text("", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)), const Text("")],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(right: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text("",
            //           style:
            //               TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            //       Container(
            //         decoration: BoxDecoration(
            //            style: ElevatedButton.styleFrom(
            //           primary: Theme.of(context).primaryColor,),
            //           borderRadius: BorderRadius.all(Radius.circular(25)),
            //         ),
            //         margin: EdgeInsets.symmetric(horizontal: 20),
            //         width: 200,
            //         //  style: ElevatedButton.styleFrom(
            //           primary: Theme.of(context).primaryColor,),
            //         height: 50,
            //         child: TextButton(
            //           child: Text(
            //             "Buy Subscription",
            //             style: TextStyle(color: Colors.white),
            //           ),
            //           onPressed: () {
            //             print("accept");
            //           },
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _services(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new ServicesPage(userDate?.id ?? "")));
      },
      child: Container(
        // width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.all(10),
        height: 150,
        width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.settings,
                color:Theme.of(context).primaryColor ,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Services",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _task(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new TaskListPage()));
      },
      child: Container(
        // width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.all(10),
        height: 150,
        width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark,
                color:Theme.of(context).primaryColor ,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Tasks",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _earning(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new EarningPage()));
      },
      child: Container(
        // width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.all(10),
        height: 150,
        width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "\$ 150",
                style: TextStyle( color:Theme.of(context).primaryColor , fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Earning",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _about(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.all(10),
      height: 150,
      width: MediaQuery.of(context).size.width / 2 - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contact_support,
              color:Theme.of(context).primaryColor ,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "About",
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _policy(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => new TermsConditionPage()));
      },
      child: Container(
        // width: MediaQuery.of(context).size.width - 50,
        margin: EdgeInsets.all(10),
        height: 150,
        width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.content_paste,
                color:Theme.of(context).primaryColor ,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Privacy Policy",
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _rate(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.all(10),
      height: 150,
      width: MediaQuery.of(context).size.width / 2 - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color:Theme.of(context).primaryColor ,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Rate",
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _invite(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.all(10),
      height: 150,
      width: MediaQuery.of(context).size.width / 2 - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share,
              color:Theme.of(context).primaryColor ,
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "Invite Friends",
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("Yes"),
      onPressed: () {
        Constants().logout();
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: const Text("Are you sure you want to logout?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void getData() async {
    var user = await Constants().getUserData();
    if (user != null) {
      print(user);
      setState(() {
        userDate = user;
      });
    }
  }
}
