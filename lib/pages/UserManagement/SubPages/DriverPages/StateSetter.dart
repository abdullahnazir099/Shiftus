import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:flutter/Material.dart';

import '../../../../BusinessLogic/DataStorage.dart';
import 'AlreadyAccptedJob.dart';
import 'GetListingsPage.dart';
import 'SignUpAsDriver.dart';

class DriverStateSetter extends StatefulWidget {
  const DriverStateSetter({super.key});

  @override
  State<DriverStateSetter> createState() => _DriverStateSetterState();
}

class _DriverStateSetterState extends State<DriverStateSetter> {

  int pageIndex = 0;
  List<List<dynamic>> listings = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkListing();
  }

  checkListing() async {
    if (isUserDriver) {
      listings = await FirestoreManager.getDriverListings();

      print(listings.length);

      if (listings.isNotEmpty) {
        setState(() {
          pageIndex = 2;
        });
      }
      else {
        setState(() {
          pageIndex = 1;
        });
      }
    }
    else {
      setState(() {
        pageIndex = 3;
      });
    }
  }

  updateDriverListingState(bool accepted) {
    if (accepted) {
      setState(() {
        pageIndex = 2;
      });
    }
    else {
      setState(() {
        pageIndex = 1;
      });
    }
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
          child: GetListingsPage(doThisAfterAccepting: updateDriverListingState,)
      ),
      Visibility(visible: pageIndex == 2,
          child: AlreadyAcceptedJob(changePageState: updateDriverListingState, jobDetail: listings.isNotEmpty ? listings[0] : [],)
      ),
      Visibility(visible: pageIndex == 3,
          child: MakeDriver(doThisAfterBecomingDriver: updateDriverListingState)
      ),
    ]);
  }
}