import 'package:cargo_connect_testing/BusinessLogic/Firebase.dart';
import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:cargo_connect_testing/pages/HomeSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field_style.dart';
import '../../BusinessLogic/DataStorage.dart';
import '../CommonFunctions.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class EnterOTP extends StatefulWidget {
  const EnterOTP({super.key, required this.forRegistration});

  final bool forRegistration;

  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendOTP();
  }

  sendOTP() {
    print("Sending OTP to: $Reg_phoneNumber");
    FirebaseManager.verifyPhoneNumberFirebase(Reg_phoneNumber, widget.forRegistration ? OTPSuccess : GetUserData);
  }

  GetUserData() {
    // print("hi");
    RunASyncTask();
  }

  RunASyncTask () async {
    setState(() {
      isLoading = true;
    });

    await FirestoreManager.getUserData();

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeSkeleton()), (route) => false);
  }

  OTPSuccess () {
    setState(() {
      isLoading = true;
    });
    FirestoreManager.addUser(Reg_fullName, Reg_phoneNumber, Reg_CNIC, Reg_location);

    fullName = Reg_fullName;
    CNIC = Reg_CNIC;
    location = Reg_location;
    PhoneNumber = Reg_phoneNumber;
    isUserDriver = false;

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeSkeleton()), (route) => false);
  }

  parseOTP() async {
    if (!isLoading) {
      if (await FirebaseManager.enterOTP(otpController.text, context)) {
        if (widget.forRegistration) {
          print("------------------------");
          print("Entered Data");
          print("Name: $Reg_fullName");
          print("Phone: $Reg_phoneNumber");
          print("CNIC: $Reg_CNIC");
          print("Location: $Reg_location");
          print("------------------------");

          fullName = Reg_fullName;
          CNIC = Reg_CNIC;
          location = Reg_location;
          PhoneNumber = Reg_phoneNumber;
          isUserDriver = false;

          await FirestoreManager.addUser(Reg_fullName, Reg_phoneNumber, Reg_CNIC, Reg_location);
        }
        else {
          print("Getting User Data");
          FirestoreManager.getUserData();
        }

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeSkeleton()), (route) => false);
      }
      else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            // const Text(
            //   "Enter OTP",
            //   style: TextStyle(
            //     fontSize: 48,
            //     // fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            SizedBox(
              height: 200,
                child: Image(image: AssetImage("assets/otp.png"))
            ),
            SizedBox(height: 40,),
            OtpTextField(
              numberOfFields: 6,
              focusedBorderColor: Color(0xff3F51B5),
              cursorColor: Color(0xff3F51B5),
              showFieldAsBox: true,
              onSubmit: (String verificationCode){
                otpController.text = verificationCode;
                parseOTP();
              }, // end onSubmit
            ),
            // UIModules.InputField(otpController, "", "OTP", 6, true),
            const SizedBox(height: 40),
            UIModules.roundedButton(parseOTP, Text("Let's go!", style: TextStyle(color: Colors.white),), Color(0xff3F51B5)!),
            Spacer(),
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
}