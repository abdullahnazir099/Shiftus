import 'package:cargo_connect_testing/BusinessLogic/Firebase.dart';
import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:cargo_connect_testing/pages/UserManagement/SubPages/UserPages/ListingPlaced.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../CommonFunctions.dart';
import 'MapsPage.dart';

class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key, required this.doThisAfterPosting});

  final Function doThisAfterPosting;

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {

  TextEditingController cargoWeightController = TextEditingController();
  TextEditingController cargoCostController = TextEditingController();
  TextEditingController pickUpLocationController = TextEditingController();
  TextEditingController dropOffLocationController = TextEditingController();
  TextEditingController fareOfferController = TextEditingController();
  TextEditingController additionalInfoController = TextEditingController();

  bool packerRequired = false;
  bool moverRequired = false;
  bool rideWithDriver = false;

  String selectedTruckTypeString = "Small Truck";
  int selectedTruckType = 1;

  String selectedCargoTypeString = "Furniture";
  int selectedCargoType = 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff3F51B5).withOpacity(0.75),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent, // Set the background color to black
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  SizedBox(height: 20,),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        selectableCargoTile(selectedCargoType, 1, 'Furniture'),
                        selectableCargoTile(selectedCargoType, 2, 'Electronics'),
                        selectableCargoTile(selectedCargoType, 3, 'Appliances'),
                        selectableCargoTile(selectedCargoType, 4, 'Clothes'),
                        selectableCargoTile(selectedCargoType, 5, 'Decoration Set'),
                        selectableCargoTile(selectedCargoType, 6, 'Furniture'),
                        selectableCargoTile(selectedCargoType, 7, 'Furniture'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  buildNumberTextField("Cargo Weight", Icons.circle, cargoWeightController),
                  SizedBox(height: 10,),
                  buildNumberTextField("Cargo Cost", Icons.circle, cargoCostController),
                  SizedBox(height: 10,),
                  buildNumberTextField("Your Fare Offer", Icons.circle, fareOfferController),
                  SizedBox(height: 10,),
                  buildTextFieldWithIcon("Additional Information", Icons.circle, additionalInfoController),
                  const SizedBox(height: 30),
                  Divider(),
                  const SizedBox(height: 10),
                  const Text("Select Options:", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Packer Required", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Spacer(),
                      Switch(
                        thumbIcon: thumbIcon,
                        value: packerRequired,
                        activeColor: Color(0xff3F51B5),
                        onChanged: (bool newValue) {
                          setState(() {
                            print(packerRequired);
                            print(newValue);
                            packerRequired = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Mover Required", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Spacer(),
                      Switch(
                        thumbIcon: thumbIcon,
                        value: moverRequired,
                        activeColor: Color(0xff3F51B5),
                        onChanged: (bool newValue) {
                          setState(() {
                            print(moverRequired);
                            print(newValue);
                            moverRequired = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Ride with Driver", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Spacer(),
                      Switch(
                        thumbIcon: thumbIcon,
                        value: rideWithDriver,
                        activeColor: Color(0xff3F51B5),
                        onChanged: (bool newValue) {
                          setState(() {
                            print(rideWithDriver);
                            print(newValue);
                            rideWithDriver = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                    UIModules.roundedButton(() => {
                      FirestoreManager.addListing(
                      FirebaseManager.user!.uid,
                      selectedTruckTypeString,
                      selectedCargoTypeString,
                      cargoCostController.text,
                      cargoWeightController.text,
                        markers[0].position,
                        markers[1].position,
                      packerRequired,
                      moverRequired,
                      rideWithDriver,
                      additionalInfoController.text,
                      fareOfferController.text,
                        pickupController.text,
                        dropoffController.text,
                    ),
                    widget.doThisAfterPosting(3),
                  }, Text("Create Listing", style: TextStyle(color: Colors.white),), Color(0xff3F51B5)!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownFieldWithIcon(String labelText, List<String> items, String selectedItem, IconData icon) {
    return SizedBox(
      height: 70,
      child: DropdownButtonFormField(
        dropdownColor: Colors.white,
        value: selectedItem,
        items: items.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Row(
              children: [
                Icon(icon, color: Colors.grey),
                const SizedBox(width: 10),
                Text(option, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            if (labelText == "Cargo Type") {
              selectedCargoTypeString = value!;
            }
          });
        },
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget buildTextField(String labelText) {
    return SizedBox(
      height: 70,
      child: TextField(
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
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
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget buildNumberTextField(String labelText, IconData icon, TextEditingController controller) {
    return Container(
      // height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.grey),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Color(0xff3F51B5)),
          border: InputBorder.none
        ),
      ),
    );
  }

  Widget buildTextFieldWithIcon(String labelText, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        maxLines: 10,
        minLines: 1,
        style: const TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Color(0xff3F51B5)),
          border: InputBorder.none
        ),
      ),
    );
  }

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check, color: Colors.white,);
      }
      return const Icon(Icons.close);
    },
  );

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

  Widget selectableCargoTile(int selectID, int assignedID, String assignedValue) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCargoType = assignedID;
          selectedCargoTypeString = assignedValue;
        });
      },
      child: Container(
        // width: 120,
        decoration: BoxDecoration(
            color: Color(0xff3F51B5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              selectID == assignedID ? BoxShadow(
                color: Colors.white.withOpacity(0.5),
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
        child: Center(
          child: Text(
            assignedValue,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
