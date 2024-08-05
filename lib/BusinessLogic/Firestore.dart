import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'DataStorage.dart';
import 'Firebase.dart';

class FirestoreManager {

  static addListing(String userID, String truckType, String cargoType, String cargoCost, String cargoWeight, LatLng pickupLocation, LatLng dropoffLocation, bool packerRequired, bool moverRequired, bool rideWithDriver, String additionalInformation, String estimatedFare, String pickupName, String dropoffName) async {
    if (userID.isEmpty || truckType.isEmpty || cargoType.isEmpty || cargoCost.isEmpty || cargoWeight.isEmpty  || additionalInformation.isEmpty || estimatedFare.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill all fields",
      );
    }
    else {
      await FirebaseFirestore.instance.collection('listings').add(
          {
            'customerID': userID,
            'customerName': fullName,
            'customerPhone': PhoneNumber,
            'truckType': truckType,
            'cargoType': cargoType,
            'cargoCost': cargoCost,
            'cargoWeight': cargoWeight,
            'pickupLocation': GeoPoint(pickupLocation.latitude, pickupLocation.longitude),
            'pickupName': pickupName,
            'dropoffLocation': GeoPoint(dropoffLocation.latitude, dropoffLocation.longitude),
            'dropoffName': dropoffName,
            'additionalInformation': additionalInformation,
            'estimatedFare': estimatedFare,
            'packerRequired': packerRequired,
            'moverRequired': moverRequired,
            'rideWithDriver': rideWithDriver,
            'driverAssigned' : '',
            'timePlaced' : DateTime.now(),
            'timeDue' : DateTime.now(),
            'status' : 'ongoing',
            'driverLocation': GeoPoint(pickupLocation.latitude, pickupLocation.longitude),
          }
      ).then((value) async => {
        Fluttertoast.showToast(
            msg: "Listing Added Successfully!",
        ),
      }).catchError((error) => {
        Fluttertoast.showToast(
            msg: "Error: $error",
        ),
      });
    }
    return;
  }

  static Future<List<List<dynamic>>> getListings() async {
    List<List<dynamic>> listings = [];

    print(truckType);

    var rawData = await FirebaseFirestore.instance.collection('listings').where('status', isEqualTo: 'ongoing').where('truckType', isEqualTo: truckType).get();

    for (int i = 0; i < rawData.docs.length; i++) {
      listings.add([
        rawData.docs[i].id,
        rawData.docs[i].data()["customerName"].toString(),
        rawData.docs[i].data()["customerPhone"].toString(),
        rawData.docs[i].data()["truckType"].toString(),
        rawData.docs[i].data()["cargoType"].toString(),
        rawData.docs[i].data()["cargoCost"].toString(),
        rawData.docs[i].data()["cargoWeight"].toString(),
        rawData.docs[i].data()["pickupLocation"],
        rawData.docs[i].data()["dropoffLocation"],
        rawData.docs[i].data()["additionalInformation"].toString(),
        rawData.docs[i].data()["estimatedFare"].toString(),
        rawData.docs[i].data()["packerRequired"].toString(),
        rawData.docs[i].data()["moverRequired"].toString(),
        rawData.docs[i].data()["rideWithDriver"].toString(),
        rawData.docs[i].data()["driverAssigned"].toString(),
        rawData.docs[i].data()["pickupName"].toString(),
        rawData.docs[i].data()["dropoffName"].toString(),
        rawData.docs[i].data()["timePlaced"],
        rawData.docs[i].data()["timeDue"],
        rawData.docs[i].data()["driverLocation"]
      ]
      );
    }

    return listings;
  }

  static Future<void> completeJob(String docID, bool complete) async {
    // Update the "driverLocation" field in the specified document
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(docID)
        .update({'status': complete ? 'complete' : 'canceled'})
        .catchError((error) => {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
      )});
  }

  static Future<void> updateCoords(String docID, GeoPoint newLocation) async {
    // Update the "driverLocation" field in the specified document
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(docID)
        .update({'driverLocation': newLocation})
        .catchError((error) => {
          Fluttertoast.showToast(
          msg: "Please fill all fields",
          )});
  }

  static Future<GeoPoint> getUpdatedCoords(String DocID) async {
    var rawData = await FirebaseFirestore.instance.collection('listings').doc(DocID).get();
    GeoPoint temp = rawData.data()!["driverLocation"];
    return temp;
  }

  static Future<List<List<dynamic>>> getUserListings() async {
    List<List<dynamic>> listings = [];

    var rawData = await FirebaseFirestore.instance.collection('listings').where('status', isEqualTo: 'ongoing').where('customerID', isEqualTo: FirebaseManager.user!.uid).get();

    print("Get User Listing: " + rawData.size.toString());

    for (int i = 0; i < rawData.docs.length; i++) {
      listings.add([
        rawData.docs[i].id,
        rawData.docs[i].data()["customerName"].toString(),
        rawData.docs[i].data()["customerPhone"].toString(),
        rawData.docs[i].data()["truckType"].toString(),
        rawData.docs[i].data()["cargoType"].toString(),
        rawData.docs[i].data()["cargoCost"].toString(),
        rawData.docs[i].data()["cargoWeight"].toString(),
        rawData.docs[i].data()["pickupLocation"],
        rawData.docs[i].data()["dropoffLocation"],
        rawData.docs[i].data()["additionalInformation"].toString(),
        rawData.docs[i].data()["estimatedFare"].toString(),
        rawData.docs[i].data()["packerRequired"].toString(),
        rawData.docs[i].data()["moverRequired"].toString(),
        rawData.docs[i].data()["rideWithDriver"].toString(),
        rawData.docs[i].data()["driverAssigned"].toString(),
        rawData.docs[i].data()["pickupName"].toString(),
        rawData.docs[i].data()["dropoffName"].toString(),
        rawData.docs[i].data()["timePlaced"],
        rawData.docs[i].data()["timeDue"],
        rawData.docs[i].data()["driverLocation"]
      ]
      );
    }

    return listings;
  }

  static Future<List<List<dynamic>>> deleteUserListings() async {
    List<List<dynamic>> listings = [];

    var rawData = await FirebaseFirestore.instance.collection('listings').where('status', isEqualTo: 'ongoing').where('customerID', isEqualTo: FirebaseManager.user!.uid).get();

    for (int i = 0; i < rawData.docs.length; i++) {
      FirebaseFirestore.instance.collection("listings").doc(rawData.docs[i].id).delete();
    }

    return listings;
  }

  static Future<List<List<dynamic>>> getDriverListings() async {
    List<List<dynamic>> listings = [];

    var rawData = await FirebaseFirestore.instance.collection('listings').where('status', isEqualTo: 'ongoing').where('driverAssigned', isEqualTo: FirebaseManager.user!.uid).get();

    for (int i = 0; i < rawData.docs.length; i++) {
      listings.add([
        rawData.docs[i].id,
        rawData.docs[i].data()["customerName"].toString(),
        rawData.docs[i].data()["customerPhone"].toString(),
        rawData.docs[i].data()["truckType"].toString(),
        rawData.docs[i].data()["cargoType"].toString(),
        rawData.docs[i].data()["cargoCost"].toString(),
        rawData.docs[i].data()["cargoWeight"].toString(),
        rawData.docs[i].data()["pickupLocation"],
        rawData.docs[i].data()["dropoffLocation"],
        rawData.docs[i].data()["additionalInformation"].toString(),
        rawData.docs[i].data()["estimatedFare"].toString(),
        rawData.docs[i].data()["packerRequired"].toString(),
        rawData.docs[i].data()["moverRequired"].toString(),
        rawData.docs[i].data()["rideWithDriver"].toString(),
        rawData.docs[i].data()["driverAssigned"].toString(),
        rawData.docs[i].data()["pickupName"].toString(),
        rawData.docs[i].data()["dropoffName"].toString(),
        rawData.docs[i].data()["timePlaced"],
        rawData.docs[i].data()["timeDue"],
        rawData.docs[i].data()["driverLocation"],
        rawData.docs[i].data()["customerID"]
      ]
      );
    }

    return listings;
  }

  static addUser(String name, String phone, String CNIC, String location) async {
    if (name.isEmpty || phone.isEmpty || CNIC.isEmpty || location.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
      );
    }
    else {
      await FirebaseFirestore.instance.collection('users').add(
          {
            'userID': FirebaseManager.user!.uid,
            'name': name,
            'phone': phone,
            'CNIC': CNIC,
            'location': location,
            'isDriver': false,
          }
      ).then((value) async => {
        Fluttertoast.showToast(
          msg: "New User Created Successfully!",
        ),
      }).catchError((error) => {
        Fluttertoast.showToast(
          msg: "Error: $error",
        ),
      });
    }
    return;
  }

  static getUserData() async {
    var rawData = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: FirebaseManager.user!.uid).get();

    print(FirebaseManager.user!.uid);
    print(rawData.size);

    fullName = rawData.docs[0].data()["name"];
    CNIC = rawData.docs[0].data()["CNIC"];
    location = rawData.docs[0].data()["location"];
    PhoneNumber = rawData.docs[0].data()["phone"];
    isUserDriver = rawData.docs[0].data()["isDriver"];

    if (isUserDriver) {
      getDriverData();
    }
  }

  static verifyUserExists(String phoneNumber) async {
    var rawData = await FirebaseFirestore.instance.collection('users').where('phone', isEqualTo: phoneNumber).get();
    if (rawData.size > 0) {
      return true;
    }
    return false;
  }

  static addDriver(String licence, String truckType, String truckNumber) async {
    bool isSuccessful = false;

    if (licence.isEmpty || truckType.isEmpty || truckNumber.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
      );
      return false;
    }
    else {
      await FirebaseFirestore.instance.collection('drivers').add(
          {
            'userID': FirebaseManager.user!.uid,
            'licence': licence,
            'truckType': truckType,
            'truckNumber': truckNumber,
          }
      ).then((value) async => {
        Fluttertoast.showToast(
          msg: "Driver Account Created Successfully!",
        ),
        isSuccessful = true,
      }).catchError((error) => {
        Fluttertoast.showToast(
          msg: "Error: $error",
        ),
        isSuccessful = false,
      });
      if (isSuccessful) {
        return true;
      }
      return false;
    }
  }

  static getDriverData() async {
    var rawData = await FirebaseFirestore.instance.collection('drivers').where('userID', isEqualTo: FirebaseManager.user!.uid).get();

    // licence = rawData.docs[0].data()["licence"];
    truckType = rawData.docs[0].data()["truckType"];
    truckNumber = rawData.docs[0].data()["truckNumber"];
  }

  static promoteUser(bool isDriver) async {
    await FirebaseFirestore.instance.collection('users')
        .where('userID', isEqualTo: FirebaseManager.user!.uid)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document per user
        String documentID = querySnapshot.docs.first.id;

        // Creates a map with the fields to update
        Map<String, dynamic> updateData = {};

        updateData['isDriver'] = isDriver;

        // Updates the user document
        await FirebaseFirestore.instance.collection('users').doc(documentID).update(updateData);

        Fluttertoast.showToast(
          msg: "User information updated!",
        );
      } else {
        Fluttertoast.showToast(
          msg: "User not found.",
        );
      }
    }).catchError((error) => {
      Fluttertoast.showToast(
        msg: "Error: $error",
      ),
    });
    return;
  }

  static Future<void> changeListingDriver(String listingID, double long, double lat) async {
    try {
      // Create a map with the field to update
      Map<String, dynamic> updateData = {
        'driverAssigned': FirebaseManager.user!.uid,
        'driverLocation': GeoPoint(lat, long),
      };

      // Update the listing document
      await FirebaseFirestore.instance.collection('listings').doc(listingID).update(updateData);

      Fluttertoast.showToast(
        msg: "Listing information updated!",
      );
    } catch (error) {
      print('Error updating listing information: $error');
      Fluttertoast.showToast(
        msg: "Error updating listing information: $error",
      );
    }
  }

  // static Future<void> completeListing(String listingID) async {
  //   try {
  //     // Create a map with the field to update
  //     Map<String, dynamic> updateData = {
  //       'status': 'complete', // Set the new value here
  //     };
  //
  //     // Update the listing document
  //     await FirebaseFirestore.instance.collection('listings').doc(listingID).update(updateData);
  //
  //     Fluttertoast.showToast(
  //       msg: "Listing Completed!",
  //     );
  //   } catch (error) {
  //     print('Error updating listing information: $error');
  //     Fluttertoast.showToast(
  //       msg: "Error updating listing information: $error",
  //     );
  //   }
  // }
}