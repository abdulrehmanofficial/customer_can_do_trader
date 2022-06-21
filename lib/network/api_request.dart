import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:can_do_customer/models/addservice.dart';
import 'package:can_do_customer/models/category.dart';
import 'package:can_do_customer/models/change_pass_model.dart';
import 'package:can_do_customer/models/email_verify.dart';
import 'package:can_do_customer/models/forgot_pass_model.dart';
import 'package:can_do_customer/models/myservices.dart';
import 'package:can_do_customer/models/oders.dart';
import 'package:can_do_customer/models/register_res.dart';
import 'package:can_do_customer/models/subscription_model.dart';
import 'package:can_do_customer/models/user.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  ApiRequest();

  Future<User?> signInCall(String _email, String _password) async {
    var url = Uri.parse(Constants.baseURL + Constants.sigin);
    var response =
        await http.post(url, body: {'email': _email, 'password': _password});

    if (response.statusCode == 200) {
      final user = userFromJson(response.body);
      User usr = user.first;
      if(usr.userType=="3" && usr.approvedStatus=="1"){
        Constants().saveUserData(response.body);
        Constants().saveUserInCahe(usr);
      }
      else{
        throw Exception('Failed to signin');
      }
     /* if (usr.status == "true") {
        Constants().saveUserInCahe(usr);
        Constants().saveUserData(response.body);
      }*/
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }


  Future<bool?> getSubscription(String userId) async {
    var url = Uri.parse(Constants.baseURL + Constants.getSubscription);
    var response =
        await http.post(url, body: {'user_id': userId});

    if (response.statusCode == 200) {
      List<SubscriptionModel> list= List<SubscriptionModel>.from(json.decode(response.body).map((x) => SubscriptionModel.fromJson(x)));
     if( list[0].status=="true"){
       return true;
     }
     else{
       return false;
     }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }


  Future<User?> editProfile(String firstName,String lastName,String address,String mobile,File? image,String userId) async {
    var url = Uri.parse(Constants.baseURL + Constants.editProfile);


    List<int> list=[];
    String base64Image = base64Encode(image?.readAsBytesSync()??list);
    var response = await http.post(
        url,
        body: {
          'first_name': firstName,
          'last_name': lastName,
           'location': "1234,1234",
          'address': address,
          'mobile': mobile,
          'image': base64Image,
          'user_id': userId
        }).catchError((onError){
      print("error: "+onError.toString());
    });

    if (response.statusCode == 200) {
      final user = userFromJson(response.body);
      User usr = user.first;
     /* if (usr.status == "true") {
        Constants().saveUserInCahe(usr);
        Constants().saveUserData(response.body);
      }
      else{

      }*/
      Constants().saveUserInCahe(usr);
      Constants().saveUserData(response.body);
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to Edit Profile');
    }
  }

  setUserSubscription() async{
      var user = await Constants().getUserData();
      addSubscription(user?.id??"0");
  }

  deleteUserSubscription() async{
      var user = await Constants().getUserData();
      deleteSubscription(user?.id??"0");
  }

  deleteSubscription(String userID) async {
    var url = Uri.parse(Constants.baseURL + Constants.deleteLatestSubscription);

    var response = await http.post(
        url,
        body: {
          'user_id': userID
        }).catchError((onError){
      print("error: "+onError.toString());
    });

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to Update Subscription');
    }
  }


  addSubscription(String userID) async {
    var url = Uri.parse(Constants.baseURL + Constants.addSubscription);

    var response = await http.post(
        url,
        body: {
          'user_id': userID
        }).catchError((onError){
      print("error: "+onError.toString());
    });

    if (response.statusCode == 200) {
      // TODO 
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to Update Subscription');
    }
  }

  addPlayerIdToApi(String userID,String playerId) async {
    var url = Uri.parse(Constants.baseURL + Constants.addPlayerId);


    List<int> list=[];

    var response = await http.post(
        url,
        body: {
          'user_id': userID,
          'player_id': playerId,
        }).catchError((onError){
      print("error: "+onError.toString());
    });

    if (response.statusCode == 200) {
      /* final user = userFromJson(response.body);
      User usr = user.first;
      *//* if (usr.status == "true") {
        Constants().saveUserInCahe(usr);
        Constants().saveUserData(response.body);
      }*//*
      Constants().saveUserInCahe(usr);
      Constants().saveUserData(response.body);
      return usr;*/
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to Update Player Id');
    }
  }


  Future<RegisterRes> rgisterCall(
      String first_name,
      String last_name,
      String _email,
      String _password,
      String location,
      String address,
      String mobile,
      String imagebase64) async {
    var url = Uri.parse(Constants.baseURL + Constants.rigister);
    var response = await http.post(url, body: {
      'first_name': first_name,
      'last_name': last_name,
      'location': location,
      'address': address,
      'mobile': mobile,
      'approved_status': '0',
      'user_type': '3',
      'image': imagebase64,
      'email': _email,
      'password': _password
    });

    if (response.statusCode == 200) {
      final user = registerResFromJson(response.body);
      RegisterRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<VerifyEmail?> emailVerifyCall(String _email) async {
    var url = Uri.parse(Constants.baseURL + Constants.verify_email);
    var response = await http
        .post(url, body: {'email': _email, 'verification_status': "1"});

    if (response.statusCode == 200) {
      final user = verifyEmailFromJson(response.body);
      VerifyEmail usr = user.first;
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<ForgotPassModel?> forgotPassCall(String _email) async {
    var url = Uri.parse(Constants.baseURL + Constants.forgotPass);
    var response = await http.post(url, body: {'email': _email});

    if (response.statusCode == 200) {
      final user = forgotPassModelFromJson(response.body);
      ForgotPassModel usr = user.first;
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<ChangePassModel?> changePassCall(String _email, String _pass) async {
    var url = Uri.parse(Constants.baseURL + Constants.changePass);
    var response =
        await http.post(url, body: {'email': _email, "password": _pass});

    if (response.statusCode == 200) {
      final user = changePassModelFromJson(response.body);
      ChangePassModel usr = user.first;
      return usr;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  Future<List<Categories>?> getCategory() async {
    var url = Uri.parse(Constants.baseURL + Constants.getCategory);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final catsjson = categoriesFromJson(response.body);

      List<Categories> cats = catsjson;

      return cats;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  //// add service

  Future<AddServiceRes> addSeriveCall(String userId, String categoryId,
      String subCatId, String latlong, String price) async {
    var url = Uri.parse(Constants.baseURL + Constants.addService);
    var response = await http.post(url, body: {
      'user_id': userId,
      'category_id': categoryId,
      'subcategories': subCatId,
      'latlong': latlong,
      'starting_price': price
    });

    if (response.statusCode == 200) {
      final user = addServiceResFromJson(response.body);
      AddServiceRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// edit service

  Future<AddServiceRes> editSeriveCall(String userId, String categoryId,
      String subCatId, String latlong, String price, String serviceId) async {
    var url = Uri.parse(Constants.baseURL + Constants.editServices);
    var response = await http.post(url, body: {
      'user_id': userId,
      'category_id': categoryId,
      'subcategories': subCatId,
      'latlong': latlong,
      'starting_price': price,
      'service_id': serviceId
    });

    if (response.statusCode == 200) {
      final user = addServiceResFromJson(response.body);
      AddServiceRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

// change online status

  Future<AddServiceRes> onlineStatusCall(String userId, String status) async {
    var url = Uri.parse(Constants.baseURL + Constants.onlineStatus);
    var response = await http.post(url, body: {
      'user_id': userId,
      'online_status': status,
    });

    if (response.statusCode == 200) {
      final user = addServiceResFromJson(response.body);
      AddServiceRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

// delete service
  Future<AddServiceRes> deleteServiceCall(String serviceId) async {
    var url = Uri.parse(Constants.baseURL + Constants.deleteService);
    var response = await http.post(url, body: {
      'service_id': serviceId,
    });

    if (response.statusCode == 200) {
      final user = addServiceResFromJson(response.body);
      AddServiceRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// get my services

  Future<List<MyServices>?> getMySeriveCall(String userId) async {
    var url = Uri.parse(Constants.baseURL + Constants.myServices);
    var response = await http.post(url, body: {
      'user_id': userId,
    });

    log("----------- services\n "+response.body);

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      if (parsed[0]["status"] == "true") {
        final user = myServicesFromJson(response.body);
        List<MyServices> reg = user;
        return reg;
      }
      else{
        return <MyServices>[];
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// get orders
  Future<List<Orders>?> getOrdersCall(String userId, String orderStatus) async {
    var url = Uri.parse(Constants.baseURL + Constants.getOrders);
    var response = await http.post(url, body: {
      'user_id': userId,
      'user_type': "2",
      'order_status': orderStatus
    });

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();

      if (parsed[0]["status"] == "true") {
        final user = ordersFromJson(response.body);
        List<Orders> reg = user;
        return reg;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// accept
  Future<AddServiceRes> acceptOrderCall(String orderId) async {
    var url = Uri.parse(Constants.baseURL + Constants.acceptOrder);
    var response = await http.post(url, body: {
      'order_id': orderId,
    });

    log("---------- Accepted Order\n"+response.body);
    if (response.statusCode == 200) {
      final user = addServiceResFromJson(response.body);
      AddServiceRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// reject
  Future<AddServiceRes> rejectOrderCall(String orderId) async {
    var url = Uri.parse(Constants.baseURL + Constants.rejectOrder);
    var response = await http.post(url, body: {
      'order_id': orderId,
    });
    log("---------- Rejected Order\n"+response.body);
    if (response.statusCode == 200) {
      final user = addServiceResFromJson(response.body);
      AddServiceRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }

  /// complete
  Future<AddServiceRes> completeOrderCall(String orderId, String price) async {
    var url = Uri.parse(Constants.baseURL + Constants.completeOrder);
    var response =
        await http.post(url, body: {'order_id': orderId, 'price': price});
    log("---------- Complete Order\n"+response.body);

    if (response.statusCode == 200) {
      final user = addServiceResFromJson(response.body);
      AddServiceRes reg = user.first;
      return reg;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to signin');
    }
  }
}
