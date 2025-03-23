import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fitboxing_app/screens/auth/login_screen.dart';
import 'package:fitboxing_app/screens/auth/forgot_password_screen.dart'; // Ensure this import exists
import 'package:fitboxing_app/screens/dashboard/home_screen.dart';
import 'package:fitboxing_app/screens/dashboard/reservation_screen.dart';
import 'package:fitboxing_app/screens/dashboard/membership_screen.dart';
import 'package:fitboxing_app/screens/session_result_screen.dart';
import 'package:fitboxing_app/screens/auth/change_password_screen.dart'; // Ensure this import exists

import 'package:fitboxing_app/providers/auth_provider.dart';
import 'package:fitboxing_app/providers/user_provider.dart';
import 'package:fitboxing_app/models/user_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user ?? User.defaultUser(); // Ensures non-null user

        return MaterialApp(
          title: 'FitBoxing App',
          home: user.id != '0' ? HomeScreen(user: user) : LoginScreen(),
          routes: {
            '/login': (context) => LoginScreen(), // Explicitly added login route
            '/forgot-password': (context) => ForgotPasswordScreen(), // Ensure it's registered
            '/change-password': (context) {
              final userId = Provider.of<UserProvider>(context, listen: false).user?.id ?? '';
              return ChangePasswordScreen(userId: userId);
            },
            '/dashboard': (context) {
              final user = Provider.of<UserProvider>(context, listen: false).user ?? User.defaultUser();
              return user.id != '0' ? HomeScreen(user: user) : LoginScreen();
            },
            '/reservation': (context) => ReservationScreen(),
            '/membership': (context) => MembershipScreen(),
            '/session-results': (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              if (args is String) {
                return SessionResultScreen(sessionId: args);
              } else {
                return const Scaffold(
                  body: Center(child: Text("Invalid session ID")),
                );
              }
            },
          },
        );
      },
    );
  }
}
