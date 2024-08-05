import 'package:cargo_connect_testing/pages/UserManagement/SubPages/Settings/TermsAndConditions.dart';
import 'package:flutter/Material.dart';

import 'CustomerSupport.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsConditions()),
              );
            },
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text("Privacy Policy",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomerSupport()),
              );
            },
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text("Customer Support",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}