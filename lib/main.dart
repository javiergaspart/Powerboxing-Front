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
  print("🚀 Navigating to Trainer Dashboard with trainerId: ${args?['trainerId']} and token: ${args?['token']}");

  if (args == null || !args.containsKey('trainerId') || !args.containsKey('token')) {
      print("❌ Error: Trainer ID or Token missing in route arguments.");
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text("Trainer ID or Token missing. Please log in again.")),
      );
  }

  return TrainerDashboard(
      trainerId: args['trainerId'] ?? "MISSING_ID",
      token: args['token'] ?? "MISSING_TOKEN",
  );
},



      },
    );
  }
}
