// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/home.dart';
class splashscreen extends StatefulWidget {
    static const String screenRoute = 'splash_screen';

  const splashscreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _splashscreenState createState() => _splashscreenState();
}
class _splashscreenState extends State<splashscreen>
    with SingleTickerProviderStateMixin {
  void intState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds:2000),(){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context) => const Home()));
    });
    return Scaffold(
        body:    Container(
        height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/Splashscreen.png'),
                fit:BoxFit.fill,
              )),
        ));
  }

}
