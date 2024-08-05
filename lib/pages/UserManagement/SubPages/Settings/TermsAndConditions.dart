import 'package:flutter/Material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.white,)
                    ),
                    const Text(
                      " Terms and Conditions",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bolded("Welcome to NutriDiet! By accessing or using our app, you agree to comply with and be bound by the following terms and conditions:"),
                    bolded("1. Acceptance of Terms:"),
                    normal("By using NutriDiet, you acknowledge that you have read, understood, and agree to be bound by these terms."),
                    bolded("2. User Registration:"),
                    normal("Users may be required to create an account to access certain features of the app. You are responsible for maintaining the confidentiality of your account information"),
                    bolded("3. Personalized Recommendations:"),
                    normal("The diet and nutrition recommendations provided by NutriDiet are general in nature and may not be suitable for everyone. Consult with a healthcare professional before making significant  dietary changes."),
                    bolded("4. User Conduct:"),
                    normal("Users must not engage in any activities that may interfere with the proper functioning of the app or infringe upon the rights of others."),
                    bolded("5. Privacy and Data Security"),
                    normal("NutriDiet is committed to protecting your privacy. User data is handled in accordance with our Privacy Policy, which can be found NutriDIET1007.com."),
                    bolded("6. Intellectual Property:"),
                    normal("All content and materials on the app, including but not limited to text, graphics, logos, and images, are the property of NutriDiet and are protected by copyright and intellectual property laws."),
                    bolded("7. Disclaimers:"),
                    normal("NutriDiet is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health providers with any questions you may have regarding a medical condition."),
                    bolded("8. Limitation of Liability:"),
                    normal("NutriDiet shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or in connection with your use of the app."),
                    bolded("9. Termination:"),
                    normal("NutriDiet reserves the right to terminate or suspend your access to the app at any time, without prior notice, for any reason."),
                    bolded("10. Governing Law:"),
                    normal("These terms and conditions shall be governed by and construed in accordance with the laws of this FYP Project."),
                    bolded("11. Changes to Terms:"),
                    normal("NutriDiet reserves the right to modify or revise these terms at any time. It is your responsibility to check for updates."),
                    bolded("Contact Information:"),
                    normal("For any questions or concerns regarding these terms and conditions, please contact us at NutriDiet1007@gmail.com."),
                  ],
                )
              ],
            )
        ),
      ),
    );
  }

  bolded(String whatToWrite) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        whatToWrite,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white
        ),
      ),
    );
  }

  normal(String whatToWrite) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        whatToWrite,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white
        ),
      ),
    );
  }
}