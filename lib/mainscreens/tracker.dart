// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class googlemaps extends StatefulWidget {
  const googlemaps({Key? key}) : super(key: key);

  @override
  State<googlemaps> createState() => _googlemapsState();
}

class _googlemapsState extends State<googlemaps> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    _location = Location();

    _cameraPosition = const CameraPosition(
        target: LatLng(
            0, 0), // this is just the example lat and lng for initializing
        zoom: 15);
    _initLocation();
    //super.initState();
  }

  //function to listen when we move position
  _initLocation() {
    _location?.getLocation().then((location) {
      _currentLocation = location;
    });
    _location?.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      moveToPosition(LatLng(
          _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
    });
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(),
          GestureDetector(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.pink[200],
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                        child: Text(
                      "track me",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing:1.5,
                        fontSize: 13,
                      ),
                    )),
                  ),
                  const SizedBox(height: 25,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.asset("asset/map.jpg")),
    );
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            // now we need a variable to get the controller of google map
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
        Positioned.fill(
            child: Align(alignment: Alignment.center, child: _getMarker()))
      ],
    );
  }
}
