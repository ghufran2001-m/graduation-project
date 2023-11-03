import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
    static const String screenRoute='register_screen';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
   bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: const Color(0xffD9D9D9),
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index){
        // ignore: avoid_print
        print(index);
      },
      items: const [    
       Icon(
        Icons.home_filled,),
        Icon(
        Icons.location_pin,),
        Icon(
        Icons.sos_rounded),
        Icon(
        Icons.phone_rounded),
         Icon(
        Icons.person),
      ]
      ),
    
    );
  }
}