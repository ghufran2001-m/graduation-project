import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/registeration/registeration_screen.dart';

class Account_screen extends StatefulWidget {
  const Account_screen({super.key});

  @override
  State<Account_screen> createState() => _Account_screenState();
}

// ignore: camel_case_types
class _Account_screenState extends State<Account_screen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('you\'re sign in '),
          MaterialButton(onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.screenRoute, 
            (route) => false);
          },
          color: Colors.pink[200],
          child: const Text('sign out'),
          )
        ],
    );
  }
}
