import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../BusinessLogic/Firestore.dart';

class AlreadyAcceptedJob extends StatefulWidget {
  const AlreadyAcceptedJob({super.key, required this.changePageState, required this.jobDetail});

  final Function changePageState;
  final List<dynamic> jobDetail;

  @override
  State<AlreadyAcceptedJob> createState() => _AlreadyAcceptedJobState();
}

class _AlreadyAcceptedJobState extends State<AlreadyAcceptedJob> {
  bool gotUser = false;

  String fullName = "Loading";
  String PhoneNumber = "Loading";
  bool _isUpdating = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pickPoint = widget.jobDetail[7];
    dropPoint = widget.jobDetail[8];
    carPoint = widget.jobDetail[19];

    getUserData();
    customMarker();
    setMaps();
  }

  void dispose() {
    _isUpdating = false;  // Set to false to stop the loop when the widget is disposed
    super.dispose();
  }

  getUserData() async {
    fullName = widget.jobDetail[1];
    PhoneNumber = widget.jobDetail[2];

    setState(() {
      gotUser = true;
    });
  }

  late GoogleMapController _controller;

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  BitmapDescriptor pickupMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor carMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor dropoffMarker = BitmapDescriptor.defaultMarker;

  void customMarker() {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/pickup.png').then((icon) {
      setState(() {
        pickupMarker = icon;
      });
    });
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/dropoff.png').then((icon) {
      setState(() {
        dropoffMarker = icon;
      });
    });
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/car.png').then((icon) {
      setState(() {
        carMarker = icon;
      });
    });
  }

  final List<Marker> markers = [];

  late GeoPoint pickPoint;
  late GeoPoint dropPoint;
  late GeoPoint carPoint;

  setMaps() async {
    await Future.delayed(Duration(seconds: 3));
    print("setting markers");
    setState(() {
      markers.add(Marker(position: LatLng(pickPoint.latitude, pickPoint.longitude), markerId: MarkerId("1"), icon: pickupMarker));
      markers.add(Marker(position: LatLng(dropPoint.latitude, dropPoint.longitude), markerId: MarkerId("2"), icon: dropoffMarker));
      markers.add(Marker(position: LatLng(carPoint.latitude, carPoint.longitude), markerId: MarkerId("3"), icon: carMarker));
    });
    createTrail(LatLng(pickPoint.latitude, pickPoint.longitude), LatLng(dropPoint.latitude, dropPoint.longitude));
    InitiateScanning();
  }

  InitiateScanning() async {

    late bool _serviceEnabled;
    late PermissionStatus _permissionGranted;
    Location location = Location();
    
    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    while(_isUpdating){
      await Future.delayed(Duration(seconds: 3));
      final locationData = await location.getLocation();

      if (locationData != null && _isUpdating) {
        final newCarPoint = LatLng(locationData.latitude!, locationData.longitude!);
        final newMarker = Marker(
          position: newCarPoint,
          markerId: MarkerId("3"),
          icon: carMarker,
        );

        setState(() {
          markers.removeWhere((m) => m.markerId.value == "3");
          markers.add(newMarker);
          FirestoreManager.updateCoords(widget.jobDetail[0], new GeoPoint(newCarPoint.latitude, newCarPoint.longitude));
          print("Location Updated");
        });
      }
    }
    //   setState(() {
    //     print("Done");
    //     markers.removeAt(2);
    //     markers.add(Marker(position: LatLng(carPoint.latitude, carPoint.longitude), markerId: MarkerId("3"), icon: carMarker));
    //     carPoint = GeoPoint(locationData.latitude!, locationData.longitude!);
    //     FirestoreManager.updateCoords(widget.jobDetail[0], GeoPoint(carPoint.latitude, carPoint.longitude));
    //   });
    // }
  }

  Future<void> createTrail(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBVU2dFEWTiwtHk5s3yU3CUYWmbpZaVBSg",
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
    );
    print(result);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      Fluttertoast.showToast(
        msg: result.errorMessage!,
      );
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color(0xff3F51B5)!,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(pickPoint.latitude, pickPoint.longitude), zoom: 15),
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          compassEnabled: false,
          polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: (controller) {
            print("object");
            _controller = controller;
          },
          markers: markers.toSet(),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xff3F51B5)!,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                      ),
                      child: Column(
                        children: [
                          Text("Name", style: TextStyle(color: Colors.white),),
                          SizedBox(height: 5,),
                          Text("Phone #", style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                      ),
                      child: Column(
                        children: [
                          Text(fullName),
                          SizedBox(height: 5,),
                          Text(PhoneNumber),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        FirestoreManager.completeJob(widget.jobDetail[0], true);
                        widget.changePageState(false);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Color(0xff3F51B5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text("Complete", style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        FirestoreManager.completeJob(widget.jobDetail[0], false);
                        widget.changePageState(false);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Center(
                              child: Text("Cancel", style: TextStyle(color: Colors.red),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  getUserDetails() {
    if (gotUser) {
      return Column(
        children: [
          textLine("Driver Name", fullName),
          const SizedBox(height: 10,),
          textLine("Driver Phone", PhoneNumber),
        ],
      );
    }
    else {
      return const Row(
        children: [
          Spacer(),
          CircularProgressIndicator(color: Colors.white,),
          Spacer(),
        ],
      );
    }
  }

  textLine(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$key: ",
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        ),
        const SizedBox(width: 5,),
        Expanded(child: Text(value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18
          ),
        )),
      ],
    );
  }
}
