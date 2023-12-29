import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/mainscreens/account.dart';
import 'package:graduation_project/mainscreens/community.dart';
import 'package:graduation_project/mainscreens/contact.dart';
import 'package:graduation_project/mainscreens/sos.dart';
import 'package:graduation_project/mainscreens/tracker.dart';
import 'package:graduation_project/sidescreens/notification.dart';

class Home extends StatefulWidget {
  static const String screenRoute = 'home_screen';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 2;
  static final List _widgetOptions = [
    const community_screen(username: '',),
    const googlemaps(),
    const SOS_screen(),
    const Contact_screen(),
    const Account_screen(),
  ];
//METHOD TO SET STATE
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
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => const Notification_screen()));
          },
          icon: const Icon(Icons.notifications_rounded),
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
          //THIS METHOD NEEDS TO BE CALLED TO CHANGE THE STATE
          onTap: _onItemTapped,
          currentIndex: _selectedIndex),
    );
  }
}
