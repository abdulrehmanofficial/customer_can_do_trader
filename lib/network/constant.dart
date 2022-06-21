import 'dart:convert';
import 'dart:math';
import 'package:can_do_customer/models/current_user.dart';
import 'package:can_do_customer/models/user.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class Constants {
  Constants();

  // static final InAppPurchase inAppPurchaseInstance = InAppPurchase.instance;

  static String oneSignalId = "a9f42a42-4641-41e6-93c4-f58c12efef11";

  static String baseURL = "https://houseofsoftwares.com/can-do/Api.php?action=";
  static String rigister = "register";
  static String sigin = "login";
  static String getSubscription = "getSubscriptions";
  static String addSubscription = "addSubscription";
  static String deleteLatestSubscription = "deleteLatestSubscription";
  static String editProfile = "updateProfile";
  static String addPlayerId = "addPlayerId";
  static String verify_email = "verifyEmail";
  static String forgotPass = "forgetPassword";
  static String changePass = "changePassword";
  static String getCategory = "getCategories";
  static String addService = "addService";
  static String myServices = "myServices";
  static String editServices = "editService";
  static String onlineStatus = "changeOnlineStatus";
  static String deleteService = "deleteService";
  static String getOrders = "myOrders";
  static String acceptOrder = "acceptOrder";
  static String rejectOrder = "rejectOrder";
  static String completeOrder = "completeOrder";

  // static bool autoConsume = true;

  // static String consumableId = 'consumable';
  // static String upgradeId = 'upgrade';
  // static String silverSubscriptionId = 'subscription_silver';
  // static String goldSubscriptionId = 'subscription_gold';
  // static List<String> productIds = <String>[
  //   consumableId,
  //   upgradeId,
  //   silverSubscriptionId,
  //   goldSubscriptionId,
  // ];

  // final String testID = 'book_test';

  // final InAppPurchase _iap = InAppPurchase.instance;



  void showAlert(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void saveUserInCahe(User user) {
    CurrentUser.id = user.id;
    CurrentUser.firstName = user.firstName;
    CurrentUser.lastName = user.lastName;
    CurrentUser.email = user.email;
    CurrentUser.location = user.location;
    CurrentUser.mobile = user.mobile;
    CurrentUser.image = user.image;
    CurrentUser.image = user.image;
    CurrentUser.subscription = user.subscription;

  }

  void saveUserData(String jsonstr) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    sharedUser.setString('user', jsonstr);
  }

  void saveLatLng(String lat, String lng) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('lat', lat);
    sharedUser.setString('lng', lng);
    print("location saved");
  }

  void logout() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    // var jsonstr = userToJson();

    sharedUser.remove('user');
  }

  Future<User?> getUserData() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String? userMap = sharedUser.getString('user');
    if (userMap != null && userMap != "") {
      User user = userFromJson(userMap).first;
      return user;
    }
    return null;
  }

  void saveUserOnlineStatus() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    sharedUser.setString('isOnline', CurrentUser.isOnline);
  }

  void getOnlineStatus() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    CurrentUser.isOnline = sharedUser.getString('isOnline') ?? "1";
  }

  double calculateDistance(String currentLoc, String otherLoc) {
    var currArr = currentLoc.split(',');
    var otherArr = otherLoc.split(',');

    double startLat = double.parse(currArr[0]);
    double startLng = double.parse(currArr[1]);
    double endLat = double.parse(otherArr[0]);
    double endLng = double.parse(otherArr[1]);

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((endLat - startLat) * p)/2 +
        c(startLat * p) * c(endLat * p) *
            (1 - c((endLng - startLng) * p))/2;
    String inString = (12742 * asin(sqrt(a))).toStringAsFixed(5);
    return double.parse(inString);
  }

  Future<String> getAddress(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    print(placemarks.first.locality);
    CurrentUser.address = placemarks.first.locality;
    return placemarks.first.locality ?? "";
  }


  updatePlayerId(String userId) async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    ApiRequest().addPlayerIdToApi(userId, osUserID??"0").then((user) {

    });

  }

}

// calculate distance

// Future<String> getUserLocation() async {
//   //call this async method from whereever you need

//   LocationData? myLocation;
//   String error;
//   Location location = new Location();
//   try {
//     myLocation = await location.getLocation();
//   } on PlatformException catch (e) {
//     if (e.code == 'PERMISSION_DENIED') {
//       error = 'please grant permission';
//       print(error);
//     }
//     if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
//       error = 'permission denied- please enable it from app settings';
//       print(error);
//     }
//     myLocation = null;
//   }
//   //currentLocation = myLocation;

//   final coordinates = Coordinates(myLocation!.latitude!, myLocation.longitude!);
//   var addresses =
//       await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   var first = addresses.first;
//   print(
//       ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
//   return first.addressLine;
// }

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
