// To parse this JSON data, do
//
//     final myServices = myServicesFromJson(jsonString);

import 'dart:convert';

import 'package:can_do_customer/models/category.dart';

List<MyServices> myServicesFromJson(String str) =>
    List<MyServices>.from(json.decode(str).map((x) => MyServices.fromJson(x)));

String myServicesToJson(List<MyServices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyServices {
  MyServices({
    required this.status,
    required this.serviceId,
    required this.latlong,
    required this.startingPrice,
    required this.categoryName,
    required this.categoryId,
    required this.subcategories,
  });

  String status;
  String? serviceId;
  String? latlong;
  String? startingPrice;
  String? categoryName;
  String? categoryId;
  List<Subcategory> subcategories = [];

  factory MyServices.fromJson(Map<String, dynamic> json) => MyServices(
        status: json["status"],
        serviceId: json["service_id"],
        latlong: json["latlong"],
        startingPrice: json["starting_price"],
        categoryName: json["category_name"],
        categoryId: json["category_id"],
        subcategories: List<Subcategory>.from(
            json["subcategories"].map((x) => Subcategory.fromJson(x))) ,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "service_id": serviceId,
        "latlong": latlong,
        "starting_price": startingPrice,
        "category_name": categoryName,
        "category_id": categoryId,
        "subcategories":
            List<dynamic>.from(subcategories.map((x) => x.toJson())),
      };
}

// class Subcategory {
//   Subcategory({
//     required this.subcategoryId,
//     required this.subcategoryName,
//   });

//   String subcategoryId;
//   String subcategoryName;

//   factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
//         subcategoryId: json["subcategory_id"],
//         subcategoryName: json["subcategory_name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "subcategory_id": subcategoryId,
//         "subcategory_name": subcategoryName,
//       };
// }
