import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';

class UIModules {
  static InputField(TextEditingController TEC, String HT, String LB, int ML, bool DO) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(100)
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: TEC,
        keyboardType: DO ? TextInputType.phone : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: HT,
          counterText: "",
          label: Center(child: Text(LB),),
          labelStyle: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
        // inputFormatters: [
        //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')),
        // ],
        maxLength: ML,
      ),
    );
  }

  static roundedButton(Function runthis, Widget child, Color MC) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          runthis();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, backgroundColor: MC,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}