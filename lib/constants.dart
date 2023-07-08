import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kInputTextDecoration = InputDecoration(
  hintText: 'Enter a value',
  // labelText: 'Portfolio Name',
  contentPadding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kLightBlue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

// const bgColor = Color(0xff17183c); //dark blue-accent
// const kBgColor = Color(0XFF0A0E21); // bluish-black - prev
const kBgColor = Color(0XFF18222c); // bluish-black
const kPurple = Color(0xff8d48e4);
const kLightBlue = Color(0xff18bbf8);
const kCardColor = Color(0xff233446);
const kNavbarColor = Color(0xff203040);
const kFadedText = Color(0xff6a7e8f);
const kTextColor = Color(0xffe8f4fe);
const kDarkRed = Color(0xff502732);
const kLightRed = Color(0xfffd2729);
const kDarkGreen = Color(0xff184637);
const kLightGreen = Color(0xff15b153);
// const kCardColor = Colors.blue;
// bg blue -> #17183c
// purple -> #8d48e4
// light blue -> #18bbf8
// logo font color -> #0c3576
