import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/home.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class RegisterScreen extends StatefulWidget {
  static const String screenRoute = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                    top: screenHeight / 5, left: screenHeight / 50),
                child: Column(
                  children: [
                    Text(
                      "Sign In",
                      style: GoogleFonts.montserrat(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 8,
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
                  top: screenHeight / 2.5,
                ),
                child: Column(
                  children: [
                    screenState == 0 ? stateRegister() : stateOTP(),
                    SizedBox(height: 50,),
                    GestureDetector(
                      onTap: () {
                        if (screenState == 0) {
                          if (usernameController.text.isEmpty) {
                            showSnackBarText("Username is still empty!");
                          } else if (phoneController.text.isEmpty) {
                            showSnackBarText("Phone number is still empty!");
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
