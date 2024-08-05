import 'package:cargo_connect_testing/pages/CommonFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class JobDetails extends StatefulWidget {
  const JobDetails({super.key, required this.jobDetail, required this.acceptFunction,});

  final List<dynamic> jobDetail;
  final Function acceptFunction;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {

  late GoogleMapController _controller;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  Location location = Location();

  Future<void> _getUserLocation() async {

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();

    print(locationData.latitude);
    print(locationData.longitude);

    setState(() {
      _userLocation = locationData;
    });
  }

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  BitmapDescriptor pickupMarker = BitmapDescriptor.defaultMarker;
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
  }

  final List<Marker> markers = [];

  late GeoPoint pickPoint;
  late GeoPoint dropPoint;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pickPoint = widget.jobDetail[7];
    dropPoint = widget.jobDetail[8];

    setMaps();
    _getUserLocation();
    customMarker();
  }

  setMaps() async {
    await Future.delayed(Duration(seconds: 1));
    print("setting markers");
    setState(() {
      markers.add(Marker(position: LatLng(pickPoint.latitude, pickPoint.longitude), markerId: MarkerId("1"), icon: pickupMarker));
      markers.add(Marker(position: LatLng(dropPoint.latitude, dropPoint.longitude), markerId: MarkerId("2"), icon: dropoffMarker));
    });
    createTrail(LatLng(pickPoint.latitude, pickPoint.longitude), LatLng(dropPoint.latitude, dropPoint.longitude));
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
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    color: Colors.transparent,
                    child: const Center(
                      child: Icon(Icons.arrow_back, color: Colors.black,)
                    ),
                  ),
                ),
                const Text("Job Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Divider(),
            Container(
              height: 400,
              child: GoogleMap(
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
            ),
            SizedBox(height: 30,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    textLine("Pickup Location", widget.jobDetail[15]),
                    const SizedBox(height: 10,),
                    textLine("Dropoff Location", widget.jobDetail[16]),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    textLine("Customer Name", widget.jobDetail[1]),
                    const SizedBox(height: 10,),
                    textLine("Customer Contact", widget.jobDetail[2]),
                    const SizedBox(height: 10,),
                    textLine("Truck Type Required", widget.jobDetail[3]),
                    const SizedBox(height: 10,),
                    textLine("Cargo Type", widget.jobDetail[4]),
                    const SizedBox(height: 10,),
                    textLine("Cargo Cost", widget.jobDetail[5]),
                    const SizedBox(height: 10,),
                    textLine("Cargo Weight", widget.jobDetail[6]),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    textLine("Fare", widget.jobDetail[9]),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    textLine("Additional Information", widget.jobDetail[10]),
                    const SizedBox(height: 10,),
                    textLine("Packer Needed", widget.jobDetail[11] == "true" ? "Yes" : "No"),
                    const SizedBox(height: 10,),
                    textLine("Mover Needed", widget.jobDetail[12] == "true" ? "Yes" : "No"),
                    const SizedBox(height: 10,),
                    textLine("Ride With Driver", widget.jobDetail[13] == "true" ? "Yes" : "No"),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    UIModules.roundedButton(() async {
                      _serviceEnabled = await location.serviceEnabled();
                      if (_userLocation == null) {
                        _serviceEnabled = await location.requestService();
                        if (!_serviceEnabled) {
                          Fluttertoast.showToast(
                            msg: "Cannot accept, please enable location",
                          );
                        }
                        else {
                          final locationData = await location.getLocation();
                          _userLocation = locationData;
                          await Future.delayed(Duration(seconds: 2));
                          widget.acceptFunction(widget.jobDetail[0], _userLocation!.longitude, _userLocation!.latitude);
                          Navigator.pop(context);
                        }
                      }
                      else {
                        await Future.delayed(Duration(seconds: 2));
                        widget.acceptFunction(widget.jobDetail[0], _userLocation!.longitude, _userLocation!.latitude);
                        Navigator.pop(context);
                      }
                    }, Text("Accept Ride", style: TextStyle(color: Colors.white),), Color(0xff3F51B5)!),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  textLine(String key, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$key: ",
          style: const TextStyle(
            color: Color(0xff3F51B5),
            fontSize: 20
          ),
        ),
        const SizedBox(width: 5,),
        Text(value,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 16
          ),
        ),
      ],
    );
  }
}
