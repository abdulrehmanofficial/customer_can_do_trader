/*

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class PaymentService{

  PaymentService._internal();

  static final PaymentService instance = PaymentService._internal();

  /// To listen the status of connection between app and the billing server
  StreamSubscription<ConnectionResult?>? _connectionSubscription;

  /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
  ///
  /// If status is not error then app will be notied by this stream
  StreamSubscription<PurchasedItem?>? _purchaseUpdatedSubscription;


  /// To listen the errors of the purchase
  StreamSubscription<PurchaseResult?>? _purchaseErrorSubscription;

  /// List of product ids you want to fetch
  final List<String> _productIds = [
    'monthly_subscription'
  ];

  /// All available products will be store in this list
  List<IAPItem>? _products;

  /// All past purchases will be store in this list
  List<PurchasedItem>? _pastPurchases;

  /// view of the app will subscribe to this to get notified
  /// when premium status of the user changes
  ObserverList<Function> _proStatusChangedListeners =
  new ObserverList<Function>();

  /// view of the app will subscribe to this to get errors of the purchase
  ObserverList<Function(String)> _errorListeners =
  new ObserverList<Function(String)>();

  /// logged in user's premium status
  bool _isProUser = false;

  bool get isProUser => _isProUser;


  /// view can subscribe to _proStatusChangedListeners using this method
  addToProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.add(callback);
  }
  /// view can cancel to _proStatusChangedListeners using this method
  removeFromProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.remove(callback);
  }

*/
/*  /// view can subscribe to _errorListeners using this method
  addToErrorListeners(Function callback) {
    _errorListeners.add(callback);
  }
  /// view can cancel to _errorListeners using this method
  removeFromErrorListeners(Function callback) {
    _errorListeners.remove(callback);
  }*//*



  /// Call this method to notify all the subsctibers of _proStatusChangedListeners
  void _callProStatusChangedListeners() {
    _proStatusChangedListeners.forEach((Function callback) {
      callback();
    });
  }

  /// Call this method to notify all the subsctibers of _errorListeners
  void _callErrorListeners(String error) {
    _errorListeners.forEach((Function callback) {
      callback(error);
    });
  }


  /// Call this method at the startup of you app to initialize connection
  /// with billing server and get all the necessary data
  void initConnection() async {
    await FlutterInappPurchase.instance.initConnection;
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {});

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_handlePurchaseError);

    _getItems();
    _getPastPurchases();
  }
  /// call when user close the app
  void dispose() {
    _connectionSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    _purchaseUpdatedSubscription?.cancel();
    FlutterInappPurchase.instance.endConnection;
  }




  void _handlePurchaseError(PurchaseResult? purchaseError) {
    _callErrorListeners(purchaseError?.message??"");
  }

  /// Called when new updates arrives at ``purchaseUpdated`` stream
  void _handlePurchaseUpdate(PurchasedItem? productItem) async {
    if (Platform.isAndroid) {
      await _handlePurchaseUpdateAndroid(productItem);
    } else {
      await _handlePurchaseUpdateIOS(productItem);
    }
  }



  Future<void> _handlePurchaseUpdateIOS(PurchasedItem? purchasedItem) async {
    switch (purchasedItem?.transactionStateIOS) {
      case TransactionState.deferred:
      // Edit: This was a bug that was pointed out here : https://github.com/dooboolab/flutter_inapp_purchase/issues/234
      // FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.failed:
        _callErrorListeners("Transaction Failed");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        await _verifyAndFinishTransaction(purchasedItem);
        break;
      case TransactionState.purchasing:
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }
  /// three purchase state https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState
  /// 0 : UNSPECIFIED_STATE
  /// 1 : PURCHASED
  /// 2 : PENDING
  Future<void> _handlePurchaseUpdateAndroid(PurchasedItem? purchasedItem) async {
    switch (purchasedItem?.purchaseStateAndroid) {
      case 1:
        if (!purchasedItem.isAcknowledgedAndroid) {
          await _verifyAndFinishTransaction(purchasedItem);
        }
        break;
      default:
        _callErrorListeners("Something went wrong");
    }
  }



  /// Call this method when status of purchase is success
  /// Call API of your back end to verify the reciept
  /// back end has to call billing server's API to verify the purchase token
  _verifyAndFinishTransaction(PurchasedItem? purchasedItem) async {
    bool isValid = false;
    try {
      // Call API
      isValid = await _verifyPurchase(purchasedItem);
    } on NoInternetException {
      _callErrorListeners("No Internet");
      return;
    } on Exception {
      _callErrorListeners("Something went wrong");
      return;
    }

    if (isValid) {
      FlutterInappPurchase.instance.finishTransaction(purchasedItem);
      _isProUser = true;
      // save in sharedPreference here
      _callProStatusChangedListeners();
    } else {
      _callErrorListeners("Varification failed");
    }
  }


  Future<List<IAPItem>> get products async {
    if (_products == null) {
      await _getItems();
    }
    return _products;
  }

  Future<void> _getItems() async {
    List<IAPItem> items =
    await FlutterInappPurchase.instance.getSubscriptions(_productIds);
    _products = [];
    for (var item in items) {
      this._products.add(item);
    }
  }


  void _getPastPurchases() async {
    // remove this if you want to restore past purchases in iOS
    if (Platform.isIOS) {
      return;
    }
    List<PurchasedItem>? purchasedItems =
    await FlutterInappPurchase.instance.getAvailablePurchases();

    for (var purchasedItem in purchasedItems??[]) {
      bool isValid = false;

      if (Platform.isAndroid) {
        Map map = json.decode(purchasedItem.transactionReceipt);
        // if your app missed finishTransaction due to network or crash issue
        // finish transactins
        if (!map['acknowledged']) {
          isValid = await _verifyPurchase(purchasedItem);
          if (isValid) {
            FlutterInappPurchase.instance.finishTransaction(purchasedItem);
            _isProUser = true;
            _callProStatusChangedListeners();
          }
        } else {
          _isProUser = true;
          _callProStatusChangedListeners();
        }
      }
    }

    _pastPurchases = [];
    _pastPurchases.addAll(purchasedItems??[]);
  }


  Future<Null> buyProduct(IAPItem item) async {
    try {
      await FlutterInappPurchase.instance.requestSubscription(item?.productId??"");
    } catch (error) {
    }
  }



}*/



// import 'dart:async';
// import 'dart:io';

// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// const String testID = 'candotrader.trader.subscription';


// class PaymentService{

//   PaymentService._internal();

//   static final PaymentService instance = PaymentService._internal();

//   final InAppPurchase _iap = InAppPurchase.instance;

//   // checks if the API is available on this device
//   bool _isAvailable = false;

//   // keeps a list of products queried from Playstore or app store
//   List<ProductDetails> products = [];

//   // List of users past purchases
//   List<PurchaseDetails> _purchases = [];

//   // subscription that listens to a stream of updates to purchase details
//   late StreamSubscription _subscription;

//   // used to represents consumable credits the user can buy
//   int _coins = 0;


//   Future<void> initialize() async {

//     // Check availability of InApp Purchases
//     _isAvailable = await _iap.isAvailable();


//     // perform our async calls only when in-app purchase is available
//     if(_isAvailable){

//       await getUserProducts();
//       //await _getPastPurchases();
//       verifyPurchases();

//       // listen to new purchases and rebuild the widget whenever
//       // there is a new purchase after adding the new purchase to our
//       // purchase list

//       _subscription = _iap.purchaseStream.listen((data){

//         _purchases.addAll(data);
//         verifyPurchases();
//         ///
//       /*  setState((){

//           _purchases.addAll(data);
//           _verifyPurchases();
//         })*/
//       });

//     }
//   }


//   // Method to retrieve product list
//   Future<List<ProductDetails>> getUserProducts() async {
//     Set<String> ids = {testID};
//     ProductDetailsResponse response = await _iap.queryProductDetails(ids);

//     products = response.productDetails;
//     return products;
//     ///
//    /* setState(() {
//       _products = response.productDetails;
//     });*/
//   }



//   // Method to retrieve users past purchase
// /*  Future<void> _getPastPurchases() async {
//     QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();


//     for(PurchaseDetails purchase in response.pastPurchases){
//       if(Platform.isIOS){
//         _iap.completePurchase(purchase);
//       }
//     }
//     _purchases = response.pastPurchases;
//     ///
//     *//*setState(() {
//       _purchases = response.pastPurchases;
//     });*//*
//   }*/

//   // checks if a user has purchased a certain product
//   PurchaseDetails _hasUserPurchased(String productID){
//     return _purchases.firstWhere((purchase) => purchase.productID == productID);
//   }


//   // Method to check if the product has been purchased already or not.
//   void verifyPurchases(){
//     PurchaseDetails purchase = _hasUserPurchased(testID);
//     if(purchase.status == PurchaseStatus.purchased){
//       Fluttertoast.showToast(msg: "already purchased");
//     }
//     else{
//       Fluttertoast.showToast(msg: "not purchased");
//     }
//   }

//   // Method to purchase a product
//   void buyProduct(ProductDetails prod){
//     final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
//     _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
//   }


// }
