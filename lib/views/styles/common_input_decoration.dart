import 'package:flutter/material.dart';

InputDecoration commonTextFieldDecoration(String hintText, [Widget? suffixWidget]) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      borderRadius: BorderRadius.circular(8.0),
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.blueGrey.shade400,
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    isDense: true,
    fillColor: Color(0xfff7f8f9),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.indigoAccent, width: 1.5),
      borderRadius: BorderRadius.circular(8.0),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 23.0, vertical: 18.0),
    suffixIcon: suffixWidget,
  );
}
