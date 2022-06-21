// To parse this JSON data, do
//
//     final forgotPassModel = forgotPassModelFromJson(jsonString);

import 'dart:convert';

List<ForgotPassModel> forgotPassModelFromJson(String str) =>
    List<ForgotPassModel>.from(
        json.decode(str).map((x) => ForgotPassModel.fromJson(x)));

String forgotPassModelToJson(List<ForgotPassModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForgotPassModel {
  ForgotPassModel({
    required this.status,
    required this.code,
    required this.message,
  });

  String status;
  int? code;
  String message;

  factory ForgotPassModel.fromJson(Map<String, dynamic> json) =>
      ForgotPassModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
      };
}
