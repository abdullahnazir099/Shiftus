import 'package:cargo_connect_testing/BusinessLogic/Firebase.dart';
import 'package:cargo_connect_testing/pages/UserManagement/SubPages/Settings/Settings.dart';
import 'package:flutter/material.dart';
import '../BusinessLogic/DataStorage.dart';
import 'UserManagement/Login.dart';
import 'UserManagement/SubPages/DriverPages/StateSetter.dart';
import 'UserManagement/SubPages/Profile/Profile.dart';
import 'UserManagement/SubPages/UserPages/StateSetter.dart';

final GlobalKey<ScaffoldState> customKey = GlobalKey();

class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key});

  @override
  _HomeSkeletonPageState createState() => _HomeSkeletonPageState();
}

class _HomeSkeletonPageState extends State<HomeSkeleton> {

  // ------------------------------------------------------------

  // BEFORE YOU CHANGE ANYTHING

  // READ THIS NOTE CAREFULLY

  // ADD ANY PAGES AFTER INDEX 3

  // INDEX 0, 1 and 2 ARE RESERVED FOR PROFILE, SETTINGS AND LOGOUT PAGE RESPECTIVELY

  // FOR MORE INFORMATION, KEEP A LOOKOUT FOR MORE COMMENTS IN tileMaker FUNCTION CALL AND INSIDE IndexedStack

  // ------------------------------------------------------------

  // Defaults
  int _currentIndex = 3;
  String pageTitle = "Create Listing";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isUserDriver) {
      _currentIndex = 4;
      pageTitle = "Find Jobs";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to black
      key: customKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xff3F51B5),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    fullName,
                    style: const TextStyle(fontSize: 16, color: Color(0xff3F51B5)),
                  ),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 14, color: Color(0xff3F51B5)),
                  ),
                ],
              ),
            ),
            // These are mandatory pages, DO NOT ALTER
            tileMaker(Icons.person, "Profile", "Profile", 0),
            const SizedBox(height: 10,),
            const Divider(),
            const SizedBox(height: 10,),

            // ------------------------------------------------------------

            // Add anything here, start from index THREE and onwards
            tileMaker(Icons.shopping_cart_rounded, "Customer Menu", "Book Cargo", 3), // index 3
            tileMaker(Icons.drive_eta, "Driver Menu", "Jobs", 4), // index 4 and so on...
            // tileMaker(Icons.house, "Organization Menu", "Organization", 5),
            const SizedBox(height: 10,),
            const Divider(),
            const SizedBox(height: 10,),

            // ------------------------------------------------------------

            // These are mandatory pages, DO NOT ALTER
            tileMaker(Icons.settings, "Settings", "Settings", 1),
            tileMaker(Icons.exit_to_app, "Logout", "Logout", 2),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          children: [
            Text(pageTitle, style: const TextStyle(color: Colors.white)),
            Spacer(),
            Icon(Icons.more_vert, color: Colors.white),
          ],
        ),
        backgroundColor: Color(0xff3F51B5),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: <Widget>[
        // These are mandatory pages, DO NOT ALTER
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Visibility(visible: _currentIndex == 0,
              child: const Profile()
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Visibility(visible: _currentIndex == 1,
              child: const Settings()
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Visibility(visible: _currentIndex == 2,
              child: const Placeholder()
          ),
        ),
        // Add anything AFTER this line, starting from index THREE and onwards
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Visibility(visible: _currentIndex == 3,
              child: const UserStateSetter()
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Visibility(visible: _currentIndex == 4,
              child: const DriverStateSetter()
          ),
        ),
      ]),
    );
  }

  tileMaker (IconData icon, String tileTitle, String tempPageTitle, int Index) {
    return ListTile(
      iconColor: Color(0xff3F51B5),
      leading: Icon(icon),
      title: Text(tileTitle, style: const TextStyle(color: Color(0xff3F51B5)),),
      onTap: () {
        if (Index == 2) {
          FirebaseManager.logoutAccount();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
        }
        else {
          setState(() {
            _currentIndex = Index;
            pageTitle = tempPageTitle;
          });
          Navigator.pop(context);
        }
      },
    );
  }
}