import 'package:flutter/material.dart';
import '../constants/colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white, // For scaffold background
  appBarTheme: AppBarTheme(
    color: primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    onPrimary: Colors.white, // Text or icons on primary color
    secondary: secondaryColor,
    onSecondary: Colors.white, // Text or icons on secondary color
    background: backgroundColor, // Set the background color
    onBackground: textColorPrimary, // Text color on background
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColorPrimary), // updated headline1
    bodyLarge: TextStyle(fontSize: 16, color: textColorPrimary), // updated bodyText1
    bodyMedium: TextStyle(fontSize: 14, color: textColorSecondary), // updated bodyText2
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor, // updated buttonColor
    ),
  ),
  // Other theme configurations if needed
);
