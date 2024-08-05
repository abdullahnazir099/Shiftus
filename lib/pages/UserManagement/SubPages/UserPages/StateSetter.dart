import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:cargo_connect_testing/pages/UserManagement/SubPages/UserPages/ListingPlaced.dart';
import 'package:cargo_connect_testing/pages/UserManagement/SubPages/UserPages/CreateListingPage.dart';
import 'package:flutter/Material.dart';

import 'DriverFound.dart';
import 'MapsPage.dart';

class UserStateSetter extends StatefulWidget {
  const UserStateSetter({super.key});

  @override
  State<UserStateSetter> createState() => _UserStateSetterState();
}

class _UserStateSetterState extends State<UserStateSetter> {

  int pageIndex = 0;
  List<List<dynamic>> listings = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkListing();
  }

  checkListing() async {
    listings = await FirestoreManager.getUserListings();

    if (listings.isNotEmpty) {
      if (listings[0][14] != "") {
        setState(() {
          pageIndex = 4;
        });
      }
      else {
        setState(() {
          pageIndex = 3;
        });
      }
    }
    else {
      setState(() {
        pageIndex = 1;
      });
    }
  }

  updateUserListingState(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(index: pageIndex, children: <Widget>[
      Visibility(visible: pageIndex == 0,
          child: const Center(
            child: CircularProgressIndicator(),
          )
      ),
      Visibility(visible: pageIndex == 1,
          child: MapsPage(doThisAfterPosting: updateUserListingState,)
      ),
      Visibility(visible: pageIndex == 2,
          child: CreateListingPage(doThisAfterPosting: updateUserListingState,)
      ),
      Visibility(visible: pageIndex == 3,
          child: ListingPlaced(changePageState: updateUserListingState)
      ),
      Visibility(visible: pageIndex == 4,
          child: DriverFound(changePageState: updateUserListingState, jobDetail: listings.isNotEmpty ? listings[0] : [],)
      ),
    ]);
  }
}