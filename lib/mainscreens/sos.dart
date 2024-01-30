// ignore_for_file: camel_case_types, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SOS_screen extends StatefulWidget {
  const SOS_screen({Key? key}) : super(key: key);

  @override
  State<SOS_screen> createState() => _SOS_screenState();
}

class _SOS_screenState extends State<SOS_screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // The SOS text explanation
        Container(
          color: Colors.white30,
          padding:
              const EdgeInsets.only(left: 30, top: 20, bottom: 30, right: 15),
          child: Text(
            "If you are feeling unsafe or in danger please press the button and an alert message will be sent to your contact.",
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        // The SOS button
        GestureDetector(
          onTap: () {
            // Call the SOS functionality when the button is tapped
            sendSOS();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.pink[300],
                    border: Border.all(color: Colors.white, width: 3),
                    shape: BoxShape.circle),
                child: const Center(
                  child: Text(
                    "SOS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        // The "I'm Safe" text explanation
        Container(
          color: Colors.white30,
          padding:
              const EdgeInsets.only(left: 30, top: 20, bottom: 30, right: 15),
          child: Text(
            "If everything is okay press the (I'm safe) button so your contact will know.",
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        // The "I'm Safe" button
        GestureDetector(
          onTap: () {
            // Call the "I'm Safe" functionality when the button is tapped
            sendImSafe();
          },
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.green[300],
                border: Border.all(color: Colors.white, width: 3),
                shape: BoxShape.circle),
            child: const Center(
              child: Text(
                "I'm Safe",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void sendSOS() async {
    try {
      // Get the current user's ID (assuming you're using Firebase Authentication)
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the user's current location
      Position position = await _getCurrentLocation();

      // Prepare the SOS message
      String message =
          'Hey, I don\'t feel safe. This is my location: ${position.latitude}, ${position.longitude}';

      // Send the SOS message to Cloud Firestore
      await FirebaseFirestore.instance.collection('sos_messages').add({
        'user_id': userId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
// Display a notification or confirmation to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS Message is Sent!'),
        ),
      );
      // You can now add additional logic, like showing a confirmation message to the user.
    } catch (e) {
      // Handle exceptions, e.g., if location permission is denied
      print('Error sending SOS: $e');
    }
  }

  void sendImSafe() async {
    try {
      // Get the current user's ID (assuming you're using Firebase Authentication)
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Prepare the "I'm Safe" message
      String message = 'I\'m safe and everything is fine.';

      // Send the "I'm Safe" message to Cloud Firestore
      await FirebaseFirestore.instance.collection('safe_messages').add({
        'user_id': userId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
// Display a notification or confirmation to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("I'm Safe Message is Sent!"),
        ),
      );
      // You can now add additional logic, like showing a confirmation message to the user.
    } catch (e) {
      // Handle exceptions
      print('Error sending "I\'m Safe" message: $e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    // Request permission to access the device's location
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle the case where the user denied permission
      throw Exception('Location permission denied');
    }

    // Get the current location
    return await Geolocator.getCurrentPosition();
  }
}
