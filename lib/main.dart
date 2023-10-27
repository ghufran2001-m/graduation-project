import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/firebase_options.dart';
import 'package:graduation_project/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  }
  catch(e){print('Firebase initialization erreo:$e');
  } 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Graduation',
      home: RegisterScreen()
    );
  }
}
