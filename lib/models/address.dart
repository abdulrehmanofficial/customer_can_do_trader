import 'package:can_do_customer/network/constant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class Address {
  String? lat;
  String? lng;
  String? address;

  Address(
    this.lat,
    this.lng,
  );

  void updateLoc(String _lat, String _lng) {
    lat = _lat;
    lng = _lng;
    getAdd();
  }

  void getAdd() async {
    address = await Constants().getAddress(
        double.parse(
          lat!,
        ),
        double.parse(
          lng!,
        ));
  }
}
