import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/boxer_dashboard.dart';
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
        '/boxer-dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return BoxerDashboard(
            token: args?['token'] ?? "",  
          );
        },
        '/trainer-dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          return TrainerDashboard(
            trainerId: args?['trainerId'] ?? "67bf58c5a45585d3ead2c4e5",
            token: args?['token'] ?? "",
          );
        },
      },
    );
  }
}
