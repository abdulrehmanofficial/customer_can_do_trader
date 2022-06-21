/// lib/presentation/shop/pages/shop_page.dart

import 'package:flutter/material.dart';
import 'package:can_do_customer/presentation/product_detail/pages/product_detail_page.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RatingPage extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => RatingPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Rating"),
          leading: Text(""),
        ),
        body: ListView(
          children: [
            Container(
              height: 400,
               color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "Your Current Rating",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 50,
                          ),
                        ),
                        Text(
                          "4.65",
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  _ratingView(context, 5, 0.8, 300),
                  _ratingView(context, 4, 0.6, 200),
                  _ratingView(context, 3, 0.5, 100),
                  _ratingView(context, 2, 0.35, 50),
                  _ratingView(context, 1, 0.2, 10),
                ],
              ),
            ),
            Container(
              height: 200,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 40, top: 40),
                    child: Text(
                      "Task Summary",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 40, top: 40),
                    child: Text(
                      "Total Tasks",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 40, top: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.car_rental,
                           color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          " 200",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  // rating view

  Widget _ratingView(
      BuildContext context, int starVal, double progress, int totalRating) {
    return Container(
      margin: EdgeInsets.only(left: 40, top: 10),
      child: Row(
        children: [
          Text(
            "${starVal}",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.star,
              color: Colors.yellow,
              size: 20,
            ),
          ),
          LinearPercentIndicator(
            width: 250.0,
            animation: true,
            animationDuration: 1000,
            lineHeight: 15.0,
            leading: new Text(""),
            trailing: new Text(
              "${totalRating}",
              style: TextStyle(color: Colors.white),
            ),
            percent: progress,
            center: Text(""),
            linearStrokeCap: LinearStrokeCap.butt,
            progressColor: starVal == 5 ? Colors.yellow : Colors.white,
          ),
        ],
      ),
    );
  }
}
