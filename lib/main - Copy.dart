import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/user_dashboard.dart';
import 'screens/session_booking_screen.dart';
import 'screens/session_buy_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => LoginScreen(),
      '/user-dashboard': (context) => UserDashboard(userName: "", token: ""),
      '/book-session': (context) => SessionBookingScreen(token: ""),
      '/buy-sessions': (context) => SessionBuyScreen(token: ""),
    },
  ));
}
