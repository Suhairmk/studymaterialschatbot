import 'package:flutter/material.dart';

@override
Widget buildTextfield(BuildContext context,Widget prefix,String label,TextEditingController controller,bool obsecure,
String? Function(String?)? validator, Widget  passwordicon
) {
  return TextFormField(
    
    validator: validator,
    obscureText: obsecure,
    controller: controller,
    decoration: InputDecoration(
      suffixIcon:passwordicon,
        label: Text(label),
        prefixIcon:prefix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
  );
}
