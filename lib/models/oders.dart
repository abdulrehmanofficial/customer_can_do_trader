// To parse this JSON data, do
//
//     final orders = ordersFromJson(jsonString);

import 'dart:convert';

List<Orders> ordersFromJson(String str) =>
    List<Orders>.from(json.decode(str).map((x) => Orders.fromJson(x)));

String ordersToJson(List<Orders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Orders {
  Orders({
    required this.status,
    required this.orderId,
    required this.price,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.image,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.customerLocation,
    required this.customerAddress,
  });

  String status;
  String orderId;
  String price;
  String userId;
  String firstName;
  String lastName;
  String email;
  String mobile;
  String image;
  String categoryId;
  String categoryName;
  String categoryImage;
  String customerLocation;
  String customerAddress;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        status: json["status"],
        orderId: json["order_id"],
        price: json["price"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        mobile: json["mobile"],
        image: json["image"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
        customerLocation: json["customer_location"],
        customerAddress: json["customer_address"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "order_id": orderId,
        "price": price,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
        "image": image,
        "category_id": categoryId,
        "category_name": categoryName,
        "category_image": categoryImage,
        "customer_location": customerLocation,
        "customer_address": customerAddress,
      };
}
