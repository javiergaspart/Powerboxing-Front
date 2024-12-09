import 'package:fitboxing_app/screens/dashboard/reservation_successful_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitboxing_app/screens/auth/login_screen.dart';
import 'package:fitboxing_app/screens/dashboard_screen.dart';
import 'package:fitboxing_app/screens/dashboard/reservation_screen.dart';
import 'package:fitboxing_app/screens/membership_screen.dart';
import 'package:fitboxing_app/screens/session_result_screen.dart';
import 'package:fitboxing_app/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:fitboxing_app/providers/auth_provider.dart';
import 'package:fitboxing_app/providers/user_provider.dart';  // Import the UserProvider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // Initialize the provider here
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(  // Use MultiProvider to provide both AuthProvider and UserProvider
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),  // AuthProvider
        ChangeNotifierProvider(create: (context) => UserProvider()),  // UserProvider
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/dashboard': (context) => DashboardScreen(),
          '/reservation': (context) => ReservationScreen(),
          '/membership': (context) => MembershipScreen(),
          '/session-results': (context) {
            // Retrieve sessionId from the route arguments
            final sessionId = ModalRoute.of(context)?.settings.arguments as String;
            return SessionResultScreen(sessionId: sessionId);
          },
        },
      ),
    );
  }
}
