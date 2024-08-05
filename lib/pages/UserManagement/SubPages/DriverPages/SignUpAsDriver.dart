import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:flutter/Material.dart';

import '../../../../BusinessLogic/DataStorage.dart' as DS;
import '../../../CommonFunctions.dart';

class MakeDriver extends StatefulWidget {
  const MakeDriver({super.key, required this.doThisAfterBecomingDriver});

  final Function doThisAfterBecomingDriver;

  @override
  State<MakeDriver> createState() => _MakeDriverState();
}

class _MakeDriverState extends State<MakeDriver> {
  List<String> truckTypes = [
    '',
    'Small Truck',
    'Pick-Up Truck',
    'Box Truck',
    'Chiller Truck',
    'Flatbed Truck',
    'Trailer',
    'Van',
  ];

  bool isLoading = false;

  String selectedTruckTypeString = "Small Truck";
  int selectedTruckType = 1;

  TextEditingController licenseNumber = TextEditingController();
  TextEditingController truckNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Set the background color to black
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SizedBox(width: 15,),
                Expanded(
                  child: Text("GO Driver",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 32,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 15,),
                Expanded(
                  child: Text("Fill out the form below to become a driver",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            UIModules.InputField(licenseNumber, "", "License Number", 13, true),
            // buildNumberTextField("License Number", Icons.code, licenseNumber),
            const SizedBox(height: 20),
            UIModules.InputField(truckNumber, "", "Truck Number", 13, false),
            // buildNumberTextField("Truck Number", Icons.drive_eta, truckNumber),
            const SizedBox(height: 20),
            // UIModules.InputField(licenseNumber, "", "License Number", 13, true),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  selectableTile(selectedTruckType, 1, 'Small Truck', 'assets/small-truck.png'),
                  selectableTile(selectedTruckType, 2, 'Pick-Up Truck', 'assets/pickup-truck.png'),
                  selectableTile(selectedTruckType, 3, 'Box Truck', 'assets/box-truck.png'),
                  selectableTile(selectedTruckType, 4, 'Chiller Truck', 'assets/chiller-truck.png'),
                  selectableTile(selectedTruckType, 5, 'Flatbed Truck', 'assets/flatbed-truck.png'),
                  selectableTile(selectedTruckType, 6, 'Trailer', 'assets/trailer.png'),
                  selectableTile(selectedTruckType, 7, 'Van', 'assets/van.png'),
                ],
              ),
            ),
            // buildDropdownFieldWithIcon("Truck Type", truckTypes, selectedTruckType, Icons.local_shipping),
            const SizedBox(height: 40),
            UIModules.roundedButton(() async {
            setState(() {
                  isLoading = true;
                });
                bool success = await FirestoreManager.addDriver(licenseNumber.text, selectedTruckTypeString, truckNumber.text);
                await FirestoreManager.promoteUser(true);
                if (success) {
                  DS.truckType = selectedTruckTypeString;
                  DS.truckNumber = truckNumber.text;
                  DS.isUserDriver = true;
                  widget.doThisAfterBecomingDriver(false);
                }
                setState(() {
                  isLoading = false;
                });
            }, Text("Become a Driver", style: TextStyle(color: Colors.white),), Color(0xff3F51B5)),
          ],
        ),
      ),
    );
  }

  Widget selectableTile(int selectID, int assignedID, String assignedValue, String picUrl) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTruckType = assignedID;
          selectedTruckTypeString = assignedValue;
        });
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            selectID == assignedID ? BoxShadow(
              color: Color(0xff3F51B5).withOpacity(1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ) : BoxShadow(
              color: Colors.transparent,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Image(image: AssetImage(picUrl))
            ),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff3F51B5),
                  borderRadius: BorderRadius.circular(100)
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Center(
                child: Text(assignedValue,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget buildDropdownFieldWithIcon(String labelText, List<String> items, String selectedItem, IconData icon) {
  //   return SizedBox(
  //     height: 70,
  //     child: DropdownButtonFormField(
  //       dropdownColor: Colors.white,
  //       value: selectedItem,
  //       items: items.map((option) {
  //         return DropdownMenuItem(
  //           value: option,
  //           child: Row(
  //             children: [
  //               Icon(icon, color: Colors.black),
  //               const SizedBox(width: 10),
  //               Text(option, style: const TextStyle(color: Colors.black)),
  //             ],
  //           ),
  //         );
  //       }).toList(),
  //       onChanged: (String? value) {
  //         setState(() {
  //           if (labelText == "Truck Type") {
  //             selectedTruckType = value!;
  //           }
  //         });
  //       },
  //       decoration: InputDecoration(
  //         labelText: labelText,
  //         labelStyle: const TextStyle(color: Colors.black),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: const BorderSide(color: Colors.black),
  //         ),
  //         filled: true,
  //         fillColor: Colors.white,
  //       ),
  //       style: const TextStyle(color: Colors.black),
  //     ),
  //   );
  // }

  Widget buildTextField(String labelText) {
    return SizedBox(
      height: 70,
      child: TextField(
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildLocationTextField(String labelText, IconData icon, TextEditingController controller) {
    return SizedBox(
      height: 70,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildNumberTextField(String labelText, IconData icon, TextEditingController controller) {
    return SizedBox(
      height: 70,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        keyboardType: TextInputType.text,
        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldWithIcon(String labelText, IconData icon, TextEditingController controller) {
    return SizedBox(
      height: 70,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildMultiOptionWidget(String optionText, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black,
        ),
        Text(optionText, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}