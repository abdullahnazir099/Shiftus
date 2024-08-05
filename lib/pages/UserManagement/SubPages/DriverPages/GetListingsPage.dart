import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:cargo_connect_testing/pages/UserManagement/SubPages/DriverPages/JobDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetListingsPage extends StatefulWidget {
  const GetListingsPage ({super.key, required this.doThisAfterAccepting});

  final Function doThisAfterAccepting;

  @override
  State<GetListingsPage> createState() => _GetListingsPageState();
}

List<List<dynamic>> jobListings = [];

class _GetListingsPageState extends State<GetListingsPage> {

  bool isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    jobListings = await FirestoreManager.getListings();
    setState(() {
      isLoaded = true;
    });
  }

  isAccepted(String jobID, double long, double lat) {
    FirestoreManager.changeListingDriver(jobID, long, lat);
    widget.doThisAfterAccepting(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoaded ? Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: jobListings.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JobDetails(jobDetail: jobListings[index], acceptFunction: isAccepted,)),
                      );
                    },
                    child: Container(
                      // padding: const EdgeInsets.only(top: 15),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff3F51B5), width: 3),
                        color: Color(0xff3F51B5)
                      ),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text((jobListings[index][17] as Timestamp).toDate().day.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(color: Color(0xff3F51B5), fontSize: 42),),
                                  Text(
                                    "${(jobListings[index][17] as Timestamp).toDate().month.toString()} - ${(jobListings[index][17] as Timestamp).toDate().year.toString()}"
                                    , overflow: TextOverflow.ellipsis, style: TextStyle(color: Color(0xff3F51B5), fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                iconLine(Icons.person, jobListings[index][1]),
                                SizedBox(height: 5,),
                                iconLine(Icons.drive_eta, jobListings[index][3]),
                                SizedBox(height: 5,),
                                iconLine(Icons.pin_drop_outlined, jobListings[index][15]),
                                SizedBox(height: 5,),
                                iconLine(Icons.pin_drop_outlined, jobListings[index][16]),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // decoration: BoxDecoration(
                      //   color: const Color(0xffE8EAF2),
                      //   border: Border.all(color: const Color(0xffBFC2CD)),
                      // ),
                      // child: Column(
                      //   children: [
                      //     Row(
                      //       children: [
                      //         const SizedBox(width: 16),
                      //         const CircleAvatar(
                      //           radius: 30,
                      //           backgroundColor: Colors.grey,
                      //           child: Text(
                      //             "A",
                      //             style: TextStyle(fontSize: 24, color: Colors.black),
                      //           ),
                      //         ),
                      //         const SizedBox(width: 10),
                      //         Expanded(
                      //           child: Column(
                      //             children: [
                      //               textLine("Name", jobListings[index][1]),
                      //               textLine("Truck Required", jobListings[index][3]),
                      //               textLine("Pickup", jobListings[index][7]),
                      //               textLine("Dropoff", jobListings[index][8]),
                      //             ],
                      //           ),
                      //         ),
                      //         const SizedBox(width: 16),
                      //       ],
                      //     ),
                      //     const SizedBox(height: 5,),
                      //     Row(
                      //       children: [
                      //         const Spacer(),
                      //         const Text("Fare: ", style: TextStyle(fontSize: 22),),
                      //         const SizedBox(width: 5,),
                      //         Text("Rs. ${jobListings[index][10]}", style: const TextStyle(fontSize: 22),),
                      //         const SizedBox(width: 16),
                      //       ],
                      //     ),
                      //     const SizedBox(height: 5,),
                      //     Row(
                      //       children: [
                      //         Expanded(
                      //           flex: 1,
                      //           child: GestureDetector(
                      //             onTap: () {
                      //               FirestoreManager.changeListingDriver(jobListings[index][0]);
                      //               widget.doThisAfterAccepting(true);
                      //             },
                      //             child: Container(
                      //               color: Colors.green,
                      //               padding: const EdgeInsets.all(15),
                      //               child: const Center(
                      //                 child: Text("Apply",
                      //                   style: TextStyle(
                      //                     color: Colors.white
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         Expanded(
                      //           flex: 2,
                      //           child: GestureDetector(
                      //             onTap: () {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(builder: (context) => JobDetails(jobDetail: jobListings[index],)),
                      //               );
                      //             },
                      //             child: Container(
                      //               color: Colors.blueGrey,
                      //               padding: const EdgeInsets.all(15),
                      //               child: const Center(
                      //                 child: Row(
                      //                   children: [
                      //                     Spacer(),
                      //                     Text("View Details",
                      //                       style: TextStyle(
                      //                           color: Colors.white
                      //                       ),
                      //                     ),
                      //                     SizedBox(width: 10,),
                      //                     Icon(Icons.arrow_forward_sharp, color: Colors.white, size: 12,),
                      //                     Spacer(),
                      //                   ],
                      //                 )
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     )
                      //   ],
                      // ),
                    ),
                  );
                }
            )
        )  : const Center(child: CircularProgressIndicator(color: Colors.white,)),
      ],
    );
  }

  textLine(String key, String value) {
    return Row(
      children: [
        Text("$key: "),
        const SizedBox(width: 5,),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis,)),
      ],
    );
  }

  iconLine(IconData key, String value) {
    return Row(
      children: [
        Icon(key, color: Colors.white, size: 20,),
        const SizedBox(width: 5,),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white),)),
      ],
    );
  }
}