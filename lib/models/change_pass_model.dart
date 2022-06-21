// To parse this JSON data, do
//
//     final changePassModel = changePassModelFromJson(jsonString);

import 'dart:convert';

List<ChangePassModel> changePassModelFromJson(String str) =>
    List<ChangePassModel>.from(
        json.decode(str).map((x) => ChangePassModel.fromJson(x)));

String changePassModelToJson(List<ChangePassModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChangePassModel {
  ChangePassModel({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory ChangePassModel.fromJson(Map<String, dynamic> json) =>
      ChangePassModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
