import 'dart:developer';
import 'dart:io';

import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/presentation/tabs/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(""),
        leading: Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
        body: Container(
          width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(
                    "assets/images/aclogo.png",
                  ),
                ),
                // _actionSheet(context),
                SizedBox(height: 50,),
                Text("If you Want to use this application please do monthly subscription"),
                SizedBox(height: 25,),
                ElevatedButton(
                  onPressed: () async {
                    try{
                      // Fluttertoast.showToast(msg: "before buy product");
                      // var result = await FlutterPurchase.instance.initialize();
                      List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(['candotrader.trader.subscription']);
                      print(items[0].productId!);

                      // FlutterInappPurchase.purchasePromoted.listen((event) {

                      // });

                      // FlutterInappPurchase.instance.checkSubscribed(sku: 'candotrader.trader.subscription');

                      FlutterInappPurchase.purchaseUpdated.listen((item) {
                        // List<String>? transaction = item!.transactionReceipt?.split(',');
                          if(Platform.isAndroid)
                          {
                              // if(item!.purchaseStateAndroid == PurchaseState.pending)
                              // {
                              //   FlutterInappPurchase.instance.finishTransaction(item!,isConsumable: true);
                                
                              // }
                              // else 
                              if(item!.purchaseStateAndroid == PurchaseState.purchased)
                              {
                                if (!item.isAcknowledgedAndroid!) {
                                  FlutterInappPurchase.instance.finishTransaction(item,isConsumable: true);
                                }

                                ApiRequest().setUserSubscription();
                                Fluttertoast.showToast(msg: "You are now subscribed !");
                                Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => TabsPage()),
                                (Route<dynamic> route) => false,);
                              }
                          }
                      });

                      await FlutterInappPurchase.instance.requestPurchase(items[0].productId!);

                      // await FlutterInappPurchase.instance.consumeAll();

                      // var user = await Constants().getUserData();
                      // ApiRequest().addSubscription(user?.id??"0");
                      // print(purchased);
                      // await FlutterInappPurchase.instance.acknowledgePurchaseAndroid(purchased.purchaseToken!);
                      // await FlutterInappPurchase.instance.finishTransaction(purchased);
                      
                      Fluttertoast.showToast(msg: "after buy product");
                    }
                    catch(e,stackTrace){
                      log(e.toString());
                      log(stackTrace.toString());
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
              ],
            ))
    );
  }

  bool isNotEmpty(bool? isAcknowledgedAndroid) {
    if (isAcknowledgedAndroid == null) {
      return false;
    }
    return true;
  }
}
