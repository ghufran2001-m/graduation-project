import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/mainscreens/registeration_screen.dart';
import 'package:graduation_project/methods/text_box.dart';

// ignore: camel_case_types
class Account_screen extends StatefulWidget {
  const Account_screen({Key? key}) : super(key: key);

  @override
  State<Account_screen> createState() => _Account_screenState();
}

// ignore: camel_case_types
class _Account_screenState extends State<Account_screen> {
  // user
  final user = FirebaseAuth.instance.currentUser!;
  // all users
  final userCollection = FirebaseFirestore.instance.collection("Users");
  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[200],
        title: Text(
          "Edit $field",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        content: TextField(
          cursorColor: Colors.pink,
          
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: " Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Container(
              height: 40,width: 80,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white,width:3)
              ),
              child: Center(
                child:  Text(
                  "cancel",
                  style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                ),
              ),
            ),
          ),

          // save button
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Container(
              height: 40,width:80,
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white,width:3)
              ),
              child: Center(
                child:  Text(
                  "Save",
                  style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 14,
                      ),
                ),
              ),
            ),
          )
        ],
      ),
    );
    // update in firestore
    // ignore: prefer_is_empty
    if (newValue.trim().length > 0) {
      // only update if there is something in the textfield
      await userCollection.doc(user.phoneNumber).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD9D9D9),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user.phoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // profile pic
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // user number
                  Text(
                    user.phoneNumber!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),

                  // user details
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "My Details ",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  // username
                  MyTextBox(
                    text: userData['username'],
                    sectionName: 'username',
                    onPressed: () => editField('username'),
                  ),

                  // bio
                  MyTextBox(
                    text: userData['bio'],
                    sectionName: 'bio',
                    onPressed: () => editField('bio'),
                  ),

                  const SizedBox(
                    height: 60,
                  ),

                  // user posts
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "My posts ",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),

                  // sign out button
                  MaterialButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RegisterScreen.screenRoute,
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.pink[200],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          'sign out',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
