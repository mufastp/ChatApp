import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
  errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
);

//page changing functions

void nextScreen(context, Page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Page));
}

void nextScreenReplace(context, Page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: Duration(seconds: 2),
    action: SnackBarAction(
      label: "ok",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}
