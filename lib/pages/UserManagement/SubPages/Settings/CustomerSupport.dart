import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({super.key});

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
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
                        child: const Icon(Icons.arrow_back, color: Colors.black,)
                    ),
                    const Text(
                      " Customer Support",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
                inputBox("Email", email, "Enter Your Email", 1, false),
                const SizedBox(height: 30,),
                inputBox("Phone Number", phone, "Enter Your Phone Number", 1, false),
                const SizedBox(height: 30,),
                inputBox("Feedback", description, "Write Something to Forward", 10, false),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Fluttertoast.showToast(
                          msg: "Feedback Sent",
                        );
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                        decoration: BoxDecoration(
                            color: const Color(0xff3F51B5),
                            border: Border.all(color: const Color(0xff3F51B5)),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: const Text("Send", style: TextStyle(fontSize: 16, color: Colors.white),),
                      ),
                    ),
                    const Spacer(),
                  ],
                )
              ],
            )
        ),
      ),
    );
  }

  inputBox(String title, TextEditingController tempController, String hintText, int maxLines, bool kbType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.black),),
        const SizedBox(height: 20,),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.black,
                  width: 1
              )
          ),
          child: TextField(
            readOnly: kbType,
            keyboardType: TextInputType.text,
            maxLines: maxLines,
            obscureText: false,
            enableSuggestions: true,
            autocorrect: true,
            controller: tempController,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration.collapsed(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
