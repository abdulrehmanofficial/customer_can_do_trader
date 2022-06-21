// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.status,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.location,
    required this.address,
    required this.mobile,
    required this.image,
    required this.approvedStatus,
    required this.subscription,
    required this.userType,
    required this.message,
  });

  String status;
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? location;
  String? address;
  String? mobile;
  String? image;
  String? approvedStatus;
  int? subscription;
  String? userType;
  String? message;

  factory User.fromJson(Map<String, dynamic> json) => User(
        status: json["status"],
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
        location: json["location"],
        address: json["address"],
        mobile: json["mobile"],
        image: json["image"],
        approvedStatus: json["approved_status"],
        subscription: json["subscription"],
        userType: json["user_type"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "location": location,
        "address": address,
        "mobile": mobile,
        "image": image,
        "approved_status": approvedStatus,
        "subscription": subscription,
        "user_type": userType,
        "message": message
      };
}
