import 'package:cargo_connect_testing/BusinessLogic/DataStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../CommonFunctions.dart';
import 'EnterOTP.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController NameController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController cnicController = TextEditingController();

  // String? selectedGender;
  String? selectedLocation;

  // List<String?> genderOptions = ['Male', 'Female', 'Rather Not Say'];
  List<String?> locationOptions = [null, 'Lahore', 'Rawalpindi', 'Islamabad', 'Karachi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 48,
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),
            UIModules.InputField(NameController, "", "First Name", 14, false),
            const SizedBox(height: 20),
            UIModules.InputField(cnicController, "", "CNIC Number", 14, true),
            const SizedBox(height: 20),
            UIModules.InputField(PhoneController, "+923XXXXXXXXX", "Phone Number", 13, true),
            const SizedBox(height: 40),
            InputDecorator(
              decoration: InputDecoration(
                labelText: "Location",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: DropdownButtonFormField<String>(
                value: selectedLocation,
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
                items: locationOptions
                    .where((item) => item != null)
                    .map((String? option) {
                  return DropdownMenuItem<String>(
                    value: option ?? "",
                    child: Text(
                      option ?? "",
                      style: TextStyle(
                        color: selectedLocation == option ? Colors.white : Colors.white,
                      ),
                    ),
                  );
                })
                    .toList(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: Colors.black,
              ),
            ),
            // buildDropdownField("Location", selectedLocation, locationOptions),
            Spacer(),
            UIModules.roundedButton(() => {
              checkRegistrationData()
            }, Text("Send OTP", style: TextStyle(color: Colors.white),), Color(0xff3F51B5)!),
            Spacer(),
          ],
        ),
      ),
    );
  }

  // Custom InputDecorator for DropdownButtonFormField
  InputDecorator buildDropdownField(String labelText, String? selectedValue, List<String?> options) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        items: options
            .where((item) => item != null)
            .map((String? option) {
          return DropdownMenuItem<String>(
            value: option ?? "",
            child: Text(
              option ?? "",
              style: TextStyle(
                color: selectedValue == option ? Colors.black : Colors.white,
              ),
            ),
          );
        })
            .toList(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        dropdownColor: Colors.black,
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

  void checkRegistrationData() {
    if (NameController.text.isEmpty ||
        PhoneController.text.isEmpty ||
        selectedLocation == null ||
        cnicController.text.isEmpty) {
      print(NameController.text);
      print(PhoneController.text);
      print(cnicController.text);
      print(selectedLocation);
      showToast("Fields are empty, please fill all fields");
    } else {
      Reg_fullName = NameController.text;
      Reg_CNIC = cnicController.text;
      Reg_phoneNumber = PhoneController.text;
      Reg_location = selectedLocation!;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EnterOTP(forRegistration: true)),
      );
    }
  }
}