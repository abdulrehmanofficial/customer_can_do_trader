import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:can_do_customer/models/address.dart';
import 'package:can_do_customer/models/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GooglePlace extends StatefulWidget {
  Address currLocation;
  GooglePlace(this.currLocation);

  @override
  _GooglePlaceState createState() => _GooglePlaceState();
}

class _GooglePlaceState extends State<GooglePlace> {
  final List<Marker> _markers = <Marker>[];

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(CurrentUser.lat, CurrentUser.lng),
    zoom: 16,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.currLocation.lat == null) {
      widget.currLocation.updateLoc("${CurrentUser.lat}", "${CurrentUser.lng}");
    }
    _addMarker(CurrentUser.lat, CurrentUser.lng);
    moveCamera(LatLng(CurrentUser.lat, CurrentUser.lng));
  }

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, widget.currLocation);
                },
                child: TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.pop(context, widget.currLocation);
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ))
          ],
        ),
        body: Container(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(_markers),
            onTap: (la) {
              print(la);
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ));
  }

  Future<void> _addMarker(tmp_lat, tmp_lng) async {
    var markerIdVal = 2.toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
        // icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: markerId,
        position: LatLng(tmp_lat, tmp_lng),
        infoWindow: InfoWindow(
          title: "",
          snippet: '',
        ),
        onTap: () {
          print("tapped");
          // setState(() {
          //   //_showItem = true;
          // });
        },
        draggable: true,
        onDragEnd: ((newPosition) {
          print(newPosition.latitude);
          print(newPosition.longitude);
          widget.currLocation
              .updateLoc("${newPosition.latitude}", "${newPosition.longitude}");
        }));

    setState(() {
      // adding a new marker to map
      _markers.add(marker);
      _kGooglePlex = CameraPosition(
          target: LatLng(marker.position.latitude, marker.position.latitude),
          zoom: 12);
    });
  }

  // update map camera
  Future<void> moveCamera(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 12)));
  }
}
