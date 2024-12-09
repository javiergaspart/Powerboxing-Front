import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/home_screen.dart';
import 'screens/dashboard/profile_screen.dart';
import 'screens/reservation/location_select_screen.dart';
import 'screens/reservation/calendar_screen.dart';
import 'screens/reservation/payment_screen.dart';
import 'screens/session_result_screen.dart';  // Ensure session result screen is imported
import 'screens/about_us_screen.dart'; // If you have About Us page
import 'models/user_model.dart';

class AppRoutes {
  // Define the route names for easy navigation across the app
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String locationSelect = '/locationSelect';
  static const String calendar = '/calendar';
  static const String payment = '/payment';
  static const String sessionResult = '/sessionResult'; // Add session result route if necessary
  static const String aboutUs = '/aboutUs';  // Add About Us route if necessary1@1.com

  // Define your route generator method
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      
      // HomeScreen, assuming you pass some required arguments (user or token)
      case dashboard:
        final User user = settings.arguments as User;  // Extract the user object from the arguments
        return MaterialPageRoute(builder: (_) => HomeScreen(user: user));  // Pass the user to the HomeScreen

      // User Profile Screen
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      // Location Selection Screen
      case locationSelect:
        return MaterialPageRoute(builder: (_) => LocationSelectScreen());

      // Calendar Screen
      case calendar:
        return MaterialPageRoute(builder: (_) => CalendarScreen());

      // Payment Screen
      case payment:
        return MaterialPageRoute(builder: (_) => PaymentScreen());

      // Session Result Screen, passing session ID as an argument
      case sessionResult:
        final String sessionId = settings.arguments as String; // Ensure you pass the correct type
        return MaterialPageRoute(
          builder: (_) => SessionResultScreen(sessionId: sessionId),
        );

      // About Us Screen (if applicable)
      case aboutUs:
        return MaterialPageRoute(builder: (_) => AboutUsScreen());

      // Default route, return a fallback screen if no match found
      default:
        return null;
    }
  }
}
