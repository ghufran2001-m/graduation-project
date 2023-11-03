// ignore: file_names
// ignore_for_file: camel_case_types
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/registeration_screen.dart';

class logInscreen extends StatefulWidget {
  static const String screenRoute = 'logIn_screen';

  const logInscreen({super.key});

  @override
  State<logInscreen> createState() => _logInscreenState();
}

class _logInscreenState extends State<logInscreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;
String otpPin = " ";
  String countryDial = "+964";
  String verID = " ";

  int screenState = 0;

  Color pink = const Color(0xffF9B0C3);
 
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;


  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffD9D9D9),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight / 8, left: screenHeight / 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:80),
                      child: Text(
                        "Log In",
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 8,
                        ),
                      ),
                    ),
                    Text(
                      "Welcome Again you've been missed!",
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontSize: screenWidth / 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: screenHeight / 3,
                ),
                child: Column(
                  children: [
                    stateRegister() ,
                    SizedBox(height: 50,),
                    GestureDetector(
                      onTap: () {
                        if (screenState == 0) {
                          if (usernameController.text.isEmpty) {
                            showSnackBarText("Username is still empty!");
                          } else if (passwordController.text.isEmpty) {
                            showSnackBarText("password is still empty!");
                          } 
                        } 
                      },
                      child: Container(
                        height: 50,
                        width: screenWidth,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            "CONTINUE",
                            style: GoogleFonts.montserrat(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ), //login sentance
                    Container(
                      padding: const EdgeInsets.only(bottom:40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member yet? ',
                            style: GoogleFonts.montserrat(
                              color: Colors.black87.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const RegisterScreen()));
                              },
                              child: Text(
                                'Sign up now!',
                                style: GoogleFonts.montserrat(
                                  color:Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 13,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),);
  }
  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
  Widget stateRegister() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder:OutlineInputBorder (
                borderSide: BorderSide(color: pink),
                borderRadius: BorderRadius.circular(16)
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                hintText: "Username",
                fillColor: Colors.grey,
                
              ),
              
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(height: 5,),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                  focusedBorder:OutlineInputBorder (
                borderSide: BorderSide(color: pink),
                borderRadius: BorderRadius.circular(16)
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                 hintText: "Password",
                fillColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
