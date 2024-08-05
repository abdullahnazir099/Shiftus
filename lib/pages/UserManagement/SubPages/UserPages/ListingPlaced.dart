import 'package:cargo_connect_testing/BusinessLogic/Firebase.dart';
import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';

class ListingPlaced extends StatelessWidget {
  const ListingPlaced({super.key, required this.changePageState});

  final Function changePageState;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        decoration: BoxDecoration(
          color: Color(0xff3F51B5),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                Spacer(),
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100)
                  ),
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Center(
                            child: Icon(Icons.check_rounded, color: Colors.white, size: 50,),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Icon(Icons.access_time_rounded, color: Color(0xff3F51B5), size: 200,),
                Spacer(),
              ],
            ),
            const SizedBox(height: 30,),
            Text("Congratulations",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 30,),
            const Row(
              children: [
                SizedBox(width: 15,),
                Flexible(
                  child: Text("You have already placed a job listing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
              ],
            ),
            const SizedBox(height: 30,),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await FirestoreManager.deleteUserListings();
                    changePageState(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    // color: Color(0xff3F51B5),
                    decoration: BoxDecoration(
                      color: Color(0xff3F51B5),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 2)
                    ),
                    width: 200,
                    child: const Center(
                      child: Text("Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
