import 'dart:async';
import 'package:cargo_connect_testing/BusinessLogic/DataStorage.dart';
import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:cargo_connect_testing/pages/UserManagement/Registration.dart';
import 'package:cargo_connect_testing/pages/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'EnterOTP.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int resendCounter = 0;
  bool isResendVisible = true;

  bool OTPSent = false; // Added loading indicator state
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 42,
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 80),
            UIModules.InputField(phoneNumberController, "", "Phone Number", 13, true),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive OTP?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    startResendCounter();
                  },
                  child: isResendVisible
                      ? const Text("Resend", style: TextStyle(color: Colors.blue))
                      : Text(
                    "${(resendCounter ~/ 60).toString().padLeft(2, '0')}:${(resendCounter % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            UIModules.roundedButton(checkLoginData, Text("Send OTP", style: TextStyle(color: Colors.white),), Colors.grey[400]!),
            const SizedBox(height: 20),
            UIModules.roundedButton(() => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrationPage()),
              )
            }, Text("Sign Up", style: TextStyle(color: Colors.white),), Color(0xff3F51B5)),
          ],
        ),
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void startResendCounter() {
    if (isResendVisible) {
      setState(() {
        isResendVisible = false;
        resendCounter = 59;
      });

      const oneSecond = Duration(seconds: 1);
      Timer.periodic(oneSecond, (timer) {
        if (resendCounter > 0) {
          setState(() {
            resendCounter--;
          });
        } else {
          setState(() {
            isResendVisible = true;
            timer.cancel();
          });
        }
      });
    }
  }

  void checkLoginData() async {
    if (phoneNumberController.text.isEmpty) {
      showToast("Fields are empty, please fill all fields");
    } else {
      if (await FirestoreManager.verifyUserExists(phoneNumberController.text)) {
        Reg_phoneNumber = phoneNumberController.text;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EnterOTP(forRegistration: false)),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationPage()),
        );
      }
    }
  }

  void sendOTP() {
    showToast("OTP Sent!");
    // Add logic to send OTP
  }
}