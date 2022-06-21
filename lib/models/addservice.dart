// To parse this JSON data, do
//
//     final addServiceRes = addServiceResFromJson(jsonString);

import 'dart:convert';

List<AddServiceRes> addServiceResFromJson(String str) =>
    List<AddServiceRes>.from(
        json.decode(str).map((x) => AddServiceRes.fromJson(x)));

String addServiceResToJson(List<AddServiceRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddServiceRes {
  AddServiceRes({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory AddServiceRes.fromJson(Map<String, dynamic> json) => AddServiceRes(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
