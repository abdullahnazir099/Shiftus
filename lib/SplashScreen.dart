import 'package:cargo_connect_testing/pages/HomeSkeleton.dart';
import 'package:cargo_connect_testing/pages/UserManagement/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';

import 'BusinessLogic/Firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _checkerState();
}

class _checkerState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPage();
  }

  loadPage() async {
    await Future.delayed(const Duration(seconds: 1));

    print("Login State: ${FirebaseAuth.instance.currentUser != null}");

    if (FirebaseAuth.instance.currentUser != null) {
      print("Getting User Data");
      await FirestoreManager.getUserData();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeSkeleton()), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Image(image: AssetImage('assets/logo.png')),
      ),
    );
  }
}
