// ignore: file_names
// ignore_for_file: camel_case_types
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/home.dart';
import 'package:graduation_project/registeration/registeration_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class logInscreen extends StatefulWidget {
  static const String screenRoute = 'logIn_screen';

  const logInscreen({super.key});

  @override
  State<logInscreen> createState() => _logInscreenState();
}

class _logInscreenState extends State<logInscreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
     TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
  //double bottom = 0;

   String otpPin = " ";
   String countryDial = "+964";
   String verID = " ";

  int screenState = 0;

  //Color pink = const Color(0xffF9B0C3);

   Future<void> verifyPhone(String number) async {
     await FirebaseAuth.instance.verifyPhoneNumber(
     phoneNumber: number,
       timeout: const Duration(seconds: 30),
       verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!");
     },
       verificationFailed: (FirebaseAuthException e) {
         showSnackBarText("Auth Failed!");
       },
      codeSent: (String verificationId, int? resendToken) {
         showSnackBarText("OTP Sent!");
         verID = verificationId;
         setState(() {
           screenState = 1;
         });
       },
       codeAutoRetrievalTimeout: (String verificationId) {
         showSnackBarText("Timeout!");
     },
     );
   }

   Future<void> verifyOTP() async {
     await FirebaseAuth.instance.signInWithCredential(
       PhoneAuthProvider.credential(
         verificationId: verID,
         smsCode: otpPin,
     ),
     )
         .whenComplete(() {
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(
           builder: (context) => const Home(),
         ),
       );
     });
   }
  Future user() async{
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null){
        print(user.uid);
      }
      
    });
  }

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
                          } else if (phoneController.text.isEmpty) {
                            showSnackBarText("phone number is still empty!");
                           } else {
                             verifyPhone(countryDial + phoneController.text);
                           } 
                         } 
                         else {
                           if (otpPin.length >= 6) {
                             verifyOTP();
                          } else {
                            showSnackBarText("Enter OTP correctly!");
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
          Stack(
            children:[ Container(
              height: 48, width: 400,
               decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
            IntlPhoneField(
              controller: phoneController,
              showCountryFlag: true,
              showDropdownIcon: false,
              initialValue: countryDial,
              onCountryChanged: (country) {
                setState(() {
                  countryDial = "+${country.dialCode}";
                });
              },
              decoration: InputDecoration(
                hintText: "Phone Number",
                fillColor: Colors.grey,
                focusColor: Colors.white,
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
              ),
          ),
            ]
          ),
         
        ],
      ),
    );
  }
   Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "We just sent a code to ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: countryDial + phoneController.text,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "\nEnter the code here and we can continue!",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              otpPin = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: pink,
            selectedColor: pink,
            inactiveColor: Colors.black26,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't receive the code? ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenState = 0;
                    });
                  },
                  child: Text(
                    "Resend",
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
