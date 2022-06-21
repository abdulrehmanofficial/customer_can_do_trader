import 'dart:async';
import 'dart:io';

import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterPurchase{
  
  FlutterPurchase._internal();

  static final FlutterPurchase instance = FlutterPurchase._internal();

  static const String iapId = 'candotrader.trader.subscription';
  List<IAPItem> items = [];

  initialize(){
    initPlatformState();
  }


  Future<void> initPlatformState() async {
    // prepare
    var close = await FlutterInappPurchase.instance.finalize();
    var result = await FlutterInappPurchase.instance.initialize();
    // print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.


    // refresh items for android
    // String msg = await FlutterInappPurchase.instance.consumeAll();
    // print('consumeAllItems: $msg');
    await _getProduct();

    FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
    });

    FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }

  Future<Null> _getProduct() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions([iapId]);
    for (var item in items) {
      // print('${item.toString()}');
      this.items.add(item);
    }

    this.items = items;
    
    /*setState(() {
      this._items = items;
    });*/
  }

  Future<void> buyProduct(IAPItem item) async {
    try {
      print('buy product called');
      print(item);
      PurchasedItem purchased =
      await FlutterInappPurchase.instance.requestSubscription(item.productId??"");
      print(purchased);
      // String msg = await FlutterInappPurchase.instance.consumeAll();
      // print('consumeAllItems: $msg');
    } catch (error) {
      print('$error');
    }
  }

// if(Platform.isAndroid){
      //   FlutterInappPurchase.instance.acknowledgePurchaseAndroid(purchased.purchaseToken??"");
      // }

// FlutterInappPurchase.instance.finishTransaction(purchased);

// var user = await Constants().getUserData();
      // ApiRequest().addSubscription(user?.id??"0");

}