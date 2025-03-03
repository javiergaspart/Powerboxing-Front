import 'package:flutter/material.dart';

class SessionManagementScreen extends StatefulWidget {
  final String token;
  SessionManagementScreen({required this.token});

  @override
  _SessionManagementScreenState createState() => _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  List<String> sessions = ["Session 1", "Session 2", "Session 3"];

  void startSession() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Session Started!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Session Management")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sessions[index]),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text("Manage"),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: startSession,
              child: Text("Start Session"),
            ),
          ),
        ],
      ),
    );
  }
}
