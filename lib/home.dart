import 'package:flutter/material.dart';
import 'package:graduation_project/mainscreen/account.dart';
import 'package:graduation_project/mainscreen/community.dart';
import 'package:graduation_project/mainscreen/contact.dart';
import 'package:graduation_project/mainscreen/sos.dart';
import 'package:graduation_project/mainscreen/tracker.dart';
//import 'package:graduation_project/registeration_screen.dart';

class Home extends StatefulWidget {
  static const String screenRoute = 'home_screen';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex =2;
  static final List _widgetOptions = [
    const community_screen(),
    const tracker_screen(),
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
      backgroundColor: Color(0xffD9D9D9),
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
              icon: Icon(Icons.sos_rounded, size: 30,),
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
