// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

List<Categories> categoriesFromJson(String str) =>
    List<Categories>.from(json.decode(str).map((x) => Categories.fromJson(x)));

String categoriesToJson(List<Categories> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categories {
  Categories({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.subcategories,
  });

  String categoryId;
  String categoryName;
  String categoryImage;
  List<Subcategory> subcategories;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
        subcategories: List<Subcategory>.from(
            json["subcategories"].map((x) => Subcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_image": categoryImage,
        "subcategories":
            List<dynamic>.from(subcategories.map((x) => x.toJson())),
      };
}

class Subcategory {
  Subcategory({
    required this.subcategoryId,
    required this.subcategoryName,
  });

  String subcategoryId;
  String subcategoryName;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        subcategoryId: json["subcategory_id"],
        subcategoryName: json["subcategory_name"],
      );

  Map<String, dynamic> toJson() => {
        "subcategory_id": subcategoryId,
        "subcategory_name": subcategoryName,
      };
}
