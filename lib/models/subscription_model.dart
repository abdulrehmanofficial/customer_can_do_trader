import 'dart:convert';
/// status : "false"
/// message : "No Subscription Found"

SubscriptionModel subscriptionModelFromJson(String str) => SubscriptionModel.fromJson(json.decode(str));
String subscriptionModelToJson(SubscriptionModel data) => json.encode(data.toJson());
class SubscriptionModel {
  SubscriptionModel({
      String? status, 
      String? message,}){
    _status = status;
    _message = message;
}

  SubscriptionModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  String? _status;
  String? _message;
SubscriptionModel copyWith({  String? status,
  String? message,
}) => SubscriptionModel(  status: status ?? _status,
  message: message ?? _message,
);
  String? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}