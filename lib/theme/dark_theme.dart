import 'package:flutter/material.dart';
import '../constants/colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    color: darkBackgroundColor,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[300]),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor,
    textTheme: ButtonTextTheme.primary,
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor).copyWith(background: darkBackgroundColor),
  // Other theme configurations if needed
);
