import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/home.dart';
class splashscreen extends StatefulWidget {
    static const String screenRoute = 'splash_screen';

  @override
  _splashscreenState createState() => _splashscreenState();
}
class _splashscreenState extends State<splashscreen>
    with SingleTickerProviderStateMixin {
  @override
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
    Timer(const Duration(milliseconds:1000),(){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context) => Home()));
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
