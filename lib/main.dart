import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/user_dashboard.dart';
import 'screens/trainer_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PowerBoxing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/user-dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return UserDashboard(
            token: args?['token'] ?? "",  
          );
        },
        '/trainer-dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return TrainerDashboard(
            trainerName: args?['trainerName'] ?? "Trainer",
            token: args?['token'] ?? "",
          );
        },
      },
    );
  }
}
