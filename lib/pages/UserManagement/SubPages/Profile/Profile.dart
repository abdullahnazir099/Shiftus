import 'package:cargo_connect_testing/pages/CommonFunctions.dart';
import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../BusinessLogic/DataStorage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  List<String?> locationOptions = [null, 'Lahore', 'Rawalpindi', 'Islamabad', 'Karachi'];

  String? selectedLocation;

  @override
  initState() {
    nameController.text = fullName;
    selectedLocation = location;
    if (location == "") {
      selectedLocation = locationOptions[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xff3F51B5),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 48, color: Colors.white),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Function Call Success",
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)
                          ),
                          padding: const EdgeInsets.all(5),
                          height: 40,
                          width: 40,
                          child: const Center(
                            child: Icon(Icons.edit, color: Color(0xff3F51B5), size: 20,),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                fullName,
                style: const TextStyle(fontSize: 24, color: Color(0xff3F51B5)),
              ),
              Text(
                location,
                style: const TextStyle(fontSize: 20, color: Color(0xff3F51B5)),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          const Text(
            "Name",
            style: TextStyle(fontSize: 20, color: Color(0xff3F51B5)),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color(0xff3F51B5)),
            decoration: InputDecoration(
              hintText: "Enter your new name here",
              // labelText: "Name",
              labelStyle: const TextStyle(color: Color(0xff3F51B5)),
              hintStyle: const TextStyle(color: Color(0xff3F51B5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            // maxLength: 13,
          ),
          const SizedBox(height: 40,),
          const Text(
            "Location",
            style: TextStyle(fontSize: 20, color: Color(0xff3F51B5)),
          ),
          const SizedBox(height: 20,),
          DropdownButtonFormField<String>(
            iconSize: 50,
            value: selectedLocation,
            onChanged: (value) {
              setState(() {
                selectedLocation = value;
              });
            },
            items: locationOptions
                .where((item) => item != null) // Ensure only non-null items are included
                .map((String? option) {
              return DropdownMenuItem<String>(
                value: option!,
                child: Text(
                  option,
                  style: const TextStyle(
                    color: Color(0xff3F51B5),
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xff3F51B5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xff3F51B5)),
              ),
            ),
            dropdownColor: Colors.white,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: UIModules.roundedButton(() {}, Text("Save", style: TextStyle(color: Colors.white)), Color(0xff3F51B5)),

            // ElevatedButton(
            //   onPressed: () {
            //
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Color(0xff3F51B5),
            //     onPrimary: Colors.black,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   child: const Text("Save", style: TextStyle(color: Colors.white)),
            // ),
          ),
        ],
      ),
    );
  }
}