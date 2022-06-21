// To parse this JSON data, do
//
//     final verifyEmail = verifyEmailFromJson(jsonString);

import 'dart:convert';

List<VerifyEmail> verifyEmailFromJson(String str) => List<VerifyEmail>.from(
    json.decode(str).map((x) => VerifyEmail.fromJson(x)));

String verifyEmailToJson(List<VerifyEmail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VerifyEmail {
  VerifyEmail({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory VerifyEmail.fromJson(Map<String, dynamic> json) => VerifyEmail(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
