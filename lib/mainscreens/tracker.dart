// ignore_for_file: avoid_print, unused_import, use_key_in_widget_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  bool _isTracking = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _selectedContactId;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    _location = Location();

    _cameraPosition = const CameraPosition(
        target: LatLng(0, 0), // example lat and lng for initializing
        zoom: 15);
    _initLocation();

    // Initialize FCM
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming message (location update)
      // Update the UI or take other actions based on the location update
      print('Received message: ${message.data}');
    });

    // Request permission for iOS devices (required for FCM)
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');
  }

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
            onTap: _toggleTracking,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 60,
                    width: 120,
                    decoration: BoxDecoration(
                      color: _isTracking ? Colors.red : Colors.pink[200],
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Text(
                        _isTracking ? "Stop" : "Track Me",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  )
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
            blurRadius: 6,
          )
        ],
      ),
      child: ClipOval(child: Image.asset("asset/map.jpg")),
    );
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          myLocationEnabled: _isTracking, // Enable/Disable user location on map
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
        Positioned.fill(
          child: Align(alignment: Alignment.center, child: _getMarker()),
        )
      ],
    );
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
    });

    if (_isTracking) {
      // Start tracking logic
      // Show a page to select a contact to track
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectContactPage(onContactSelected: _subscribeToLiveLocation),
        ),
      );
    } else {
      // Stop tracking logic
      // Stop sharing live location with the selected contact
      // Update the UI or perform any necessary cleanup
      _unsubscribeFromLiveLocation();
    }
  }

  void _subscribeToLiveLocation(String contactId) {
    setState(() {
      _selectedContactId = contactId;
    });

    // Subscribe to a topic based on the contact ID
    _firebaseMessaging.subscribeToTopic(contactId);
  }

  void _unsubscribeFromLiveLocation() {
    if (_selectedContactId != null) {
      // Unsubscribe from the topic (stop receiving location updates)
      _firebaseMessaging.unsubscribeFromTopic(_selectedContactId!);
    }
  }
}



class SelectContactPage extends StatelessWidget {
    final Function(String) onContactSelected; // Add this line

  const SelectContactPage({Key? key, required this.onContactSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Implement UI for selecting a contact to track
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      appBar: AppBar(
        title: const Text('Select Contact to Track'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Ghufran'),
            onTap: () {
              Navigator.pop(context, 'contact1'); // Return the selected contact ID
            },
          ),
          ListTile(
            title: const Text('Rafal'),
            onTap: () {
              Navigator.pop(context, 'contact2'); // Return the selected contact ID
            },
          ),
          // Add more list items for other contacts
        ],
      ),
    );
  }
}
