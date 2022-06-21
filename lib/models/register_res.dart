// To parse this JSON data, do
//
//     final registerRes = registerResFromJson(jsonString);

import 'dart:convert';

List<RegisterRes> registerResFromJson(String str) => List<RegisterRes>.from(
    json.decode(str).map((x) => RegisterRes.fromJson(x)));

String registerResToJson(List<RegisterRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegisterRes {
  RegisterRes({
    required this.status,
    required this.code,
    required this.message,
  });

  String status;
  int? code;
  String message;

  factory RegisterRes.fromJson(Map<String, dynamic> json) => RegisterRes(
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
