// ignore_for_file: avoid_print, unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/firebase_options.dart';
import 'package:graduation_project/home.dart';
import 'package:graduation_project/mainscreens/registeration_screen.dart';
import 'package:graduation_project/sidescreens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  // Initialize Firebase Messaging
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp( MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
class MyApp extends StatelessWidget {
   MyApp({super.key});
  final _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Graduation',
     initialRoute: _auth.currentUser !=null
     ? splashscreen.screenRoute
     : RegisterScreen.screenRoute,
      routes: {
        Home.screenRoute:(context) =>  const Home(),
        splashscreen.screenRoute: (context) =>  const splashscreen(),
        // ignore: equal_keys_in_map
        RegisterScreen.screenRoute:(context) =>  const RegisterScreen(),

      },
    );
  }
}
