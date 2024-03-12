import 'package:flutter/material.dart';

@override
Widget buildContainer(context, text, icon, ontap) {
  return InkWell(
    onTap: ontap,
    child: Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 19, 139, 238),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(blurRadius: 8, spreadRadius: 2, color: Colors.grey)
          ]),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            text,
            style: TextStyle(
                color: Color.fromARGB(255, 239, 237, 237),
                fontWeight: FontWeight.w600),
          ),
        ],
      )),
    ),
  );
}
