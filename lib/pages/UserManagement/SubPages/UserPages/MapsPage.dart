import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:dio/dio.dart';

import 'CreateListingPage.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key, required this.doThisAfterPosting});

  final Function doThisAfterPosting;

  @override
  State<MapsPage> createState() => _MapsPageState();
}

final List<Marker> markers = [];

TextEditingController pickupController = TextEditingController();
TextEditingController dropoffController = TextEditingController();

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController _controller;

  String _API_KEY = "AIzaSyBVU2dFEWTiwtHk5s3yU3CUYWmbpZaVBSg";

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  BitmapDescriptor pickupMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor dropoffMarker = BitmapDescriptor.defaultMarker;

  int currentPrice = 0;

  bool selectedInput = true;

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

  convertToAddress(LatLng place) async {
    Dio dio = Dio();  //initilize dio package
    String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${place.latitude},${place.longitude}&key=$_API_KEY";

    Response response = await dio.get(apiurl); //send get request to API URL

    if(response.statusCode == 200){ //if connection is successful
      Map data = response.data; //get response data
      if(data["status"] == "OK"){ //if status is "OK" returned from REST API
        if(data["results"].length > 0){ //if there is atleast one address
          Map firstresult = data["results"][0]; //select the first address

          var address = firstresult["formatted_address"]; //get the address

          setState(() {
            if (selectedInput) pickupController.text = address;
            else dropoffController.text = address;
          });
        }
      }else{
        Fluttertoast.showToast(
          msg: "Unknown Error has occurred",
        );
      }
    }else{
      Fluttertoast.showToast(
        msg: "Error while fetching geocoding data",
      );
    }
  }


  Future<void> createTrail(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      _API_KEY,
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

  priceCalculator() {
    double distance = Geolocator.distanceBetween(markers[0].position.latitude, markers[0].position.longitude, markers[1].position.latitude, markers[1].position.longitude);
    double baseFare = 100;
    double costPerKM = 40;
    currentPrice = (baseFare + (costPerKM * (distance/1000))).round();
  }

  initState() {
    super.initState();
    customMarker();
    pickupController.text = "Select Location on Map";
    dropoffController.text = "Select Location on Map";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(33.707182, 73.050477), zoom: 15),
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          compassEnabled: false,
          polylines: Set<Polyline>.of(polylines.values),
          onTap: (ltlg) {
            if (selectedInput) {
              if (markers.length >= 1){
                markers[0] = Marker(position: ltlg, markerId: MarkerId("1"), icon: pickupMarker);
                convertToAddress(markers[0].position);
              }
              else if (markers.isEmpty){
                markers.add(Marker(position: ltlg, markerId: MarkerId("1"), icon: pickupMarker));
                convertToAddress(markers[0].position);
              }
            }
            else {
              if (markers.length == 1){
                markers.add(Marker(position: ltlg, markerId: MarkerId("2"), icon: dropoffMarker));
                convertToAddress(markers[1].position);
              }
              else if (markers.length == 2) {
                markers[1] = Marker(position: ltlg, markerId: MarkerId("2"), icon: dropoffMarker);
                convertToAddress(markers[1].position);
              }
              else {
                Fluttertoast.showToast(
                  msg: "Please enter pickup location first",
                );
                return;
              }
            }
            if(markers.length == 2) {
              polylines.clear();
              createTrail(markers[0].position, markers[1].position);
            }
            setState(() {
              print(ltlg.latitude);
              print(ltlg.longitude);
            });
          },
          onMapCreated: (controller) {
            print("object");
            _controller = controller;
          },
          markers: markers.toSet(),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(30),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff3F51B5).withOpacity(1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
              ),
              child: Column(
                children: [
                  Container(
                    // padding: EdgeInsets.all(15),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedInput = !selectedInput;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: 100,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center(
                              child: Text(selectedInput ? "Pickup" : "Dropoff"),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: selectedInput ? pickupController : dropoffController,
                            readOnly: true,
                            // keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              counterText: "",
                              // label: Center(child: Text(""),),
                              // labelStyle: const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (markers.length != 2) {
                            Fluttertoast.showToast(
                              msg: "Please select pickup and dropoff first",
                            );
                          }
                          else if (markers.length == 2) {
                            widget.doThisAfterPosting(2);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(1),
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Text("Enter Ride Details       ",
                                  style: TextStyle(
                                      color: Colors.black
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
