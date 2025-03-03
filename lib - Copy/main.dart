import 'package:flutter/material.dart';
import 'package:powerboxing_front/screens/login_screen.dart';
import 'package:powerboxing_front/screens/signup_screen.dart';
import 'package:powerboxing_front/screens/user_dashboard.dart';
import 'package:powerboxing_front/screens/trainer_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PowerBoxing App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/user-dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return UserDashboard(
            userName: args?['userName'] ?? 'User',
            token: args?['token'] ?? '',
          );
        },
        '/trainer-dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return TrainerDashboard(
            token: args?['token'] ?? '',
            trainerId: args?['trainerId'] ?? '',
          );
        },
      },
    );
  }
}
