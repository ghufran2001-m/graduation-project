import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/firebase_options.dart';
import 'package:graduation_project/home.dart';
import 'package:graduation_project/registeration/registeration_screen.dart';
import 'package:graduation_project/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  
  runApp( MyApp());
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
