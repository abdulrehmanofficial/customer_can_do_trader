import 'dart:io';

import 'package:can_do_customer/Screens/login_screen.dart';
import 'package:can_do_customer/Screens/splash_screen.dart';
import 'package:can_do_customer/Screens/subscription_screen.dart';
import 'package:can_do_customer/flutter_purchase.dart';
import 'package:can_do_customer/models/user.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:can_do_customer/payment_service.dart';
import 'package:can_do_customer/presentation/tabs/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'models/current_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CanDo Trader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
     // home: EditProfile(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? userData;
  bool isProcessingDone=false;
  @override
  void initState() {
    getLocation();
    getData();
    Constants().getOnlineStatus();
    initOneSignal();
    super.initState();
    asyncInitState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => checkForSubscribedSubscription());
  }

  

  void asyncInitState() async{
      // PaymentService.instance.initialize();
      // FlutterPurchase.instance.initialize();
      await FlutterInappPurchase.instance.initialize();
  }

  // @override
  // void dispose() async{
  //   super.dispose();
  //   await FlutterInappPurchase.instance.finalize();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CanDo Trader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen() // userData == null ? LoginScreen() : TabsPage(),
        );
  }

  Future<void> getData() async {
    var user = await Constants().getUserData();
    if (user != null) {
      Constants().saveUserInCahe(user);
      // bool subscribed = FlutterInappPurchase.instance.checkSubscribed(sku: 'candotrader.trader.subscription') as bool;
      // Fluttertoast.showToast(msg: user.id!);
      // if(!subscribed)
      // {
      //     ApiRequest().deleteUserSubscription();
      // }
      setState(() {
        userData = user;
        getSubscritpitonState();
      });
    } else {
      Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,);
    }
  }

  checkForSubscribedSubscription()
  async {
    var user = await Constants().getUserData();
    if (user != null) {
      bool activeSubscription = await getActiveSubscription();
      if(!activeSubscription)
      {
        print("delete subscription");
        ApiRequest().deleteUserSubscription();
      }
      else{
        print("have subscription");
      }
    }
  }

  getSubscritpitonState() {
    ApiRequest().getSubscription(userData?.id??"0").then((status) {
      if (status??false) {
        Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => TabsPage()),
              (Route<dynamic> route) => false,);
      } else {
        Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => SubscriptionScreen()),
              (Route<dynamic> route) => false,);
      }
    }).catchError((onError){
      Constants().showAlert(onError.toString());
    });
  }


  void getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    String loc = "${_locationData.latitude},${_locationData.longitude}";
    CurrentUser.location = loc;
    CurrentUser.lat = _locationData.latitude!;
    CurrentUser.lng = _locationData.longitude!;

    Constants()
        .saveLatLng("${_locationData.latitude}", "${_locationData.longitude}");
  }

  void initOneSignal() async {

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(Constants.oneSignalId);

    // OneSignal.shared.postNotification(OSCreateNotification());

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  Future<bool> getActiveSubscription() async{
    if (Platform.isIOS) {
      // FlutterInappPurchase.instance.finalize();
      // FlutterInappPurchase.instance.initialize();
      try{
        var history = await FlutterInappPurchase.instance.getAvailablePurchases();

        for (var purchase in history!)
          if([TransactionState.purchased, TransactionState.restored].contains(purchase.transactionStateIOS))
            return true;
      } on Exception catch(error){
        Fluttertoast.showToast(msg: error.toString());
      }
      return false;
    } else if (Platform.isAndroid) {
      try{
        List<PurchasedItem>? purchasedItems =
        await FlutterInappPurchase.instance.getAvailablePurchases();
        if(purchasedItems?.length != 0)
        {
          for (var purchase in purchasedItems!) {
            if (purchase.productId == "candotrader.trader.subscription") return true;
          }
        }
      }catch (error) {
        // Fluttertoast.showToast(msg: error.toString());
      }
      return false;
    }
    throw PlatformException(code: Platform.operatingSystem, message: "platform not supported");
  }

}
