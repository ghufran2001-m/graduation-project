// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/mainscreens/account.dart';
import 'package:graduation_project/mainscreens/community.dart';
import 'package:graduation_project/mainscreens/contact.dart';
import 'package:graduation_project/mainscreens/sos.dart';
import 'package:graduation_project/mainscreens/tracker.dart';
import 'package:graduation_project/sidescreens/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  static const String screenRoute = 'home_screen';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 2;
  int notificationCount = 0; // Initialize notification count
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      CommunityScreen(
        username: '',
        notificationCallback: (count) {
          setState(() {
            notificationCount = count;
          });
        },
      ),
      const googlemaps(),
      const SOS_screen(),
      const ContactPage(),
      const Account_screen(),
    ];

    // Handle FCM messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      setState(() {
        notificationCount++;
      });
    });

    // Handle FCM messages when the app is terminated or in the background
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print("onBackgroundMessage: $message");
      setState(() {
        notificationCount++;
      });
      // You may want to handle the message and perform actions accordingly
      // For now, we just increment the notification count
      return Future.value();
    });

    // Handle FCM messages when the app is resumed from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
      setState(() {
        notificationCount++;
      });
    });
  }

  // METHOD TO SET STATE
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Text(
            'SAWA',
            style: GoogleFonts.montserrat(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            // Handle the notification icon press (e.g., show notifications)
            // You may want to reset the notification count when the notifications are viewed
            if (notificationCount > 0) {
              // Reset the notification count
              setState(() {
                notificationCount = 0;
              });
            }
            // Navigate to the notification screen (optional)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const NotificationScreen(),
              ),
            );
          },
          icon: Stack(
            children: [
              const Icon(Icons.notifications_rounded),
              if (notificationCount > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          color: Colors.black87,
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.sos_rounded,
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_rounded),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Account',
          ),
        ],
        // THIS METHOD NEEDS TO BE CALLED TO CHANGE THE STATE
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
