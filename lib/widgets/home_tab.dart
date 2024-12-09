import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final String sessionId = "12345";  // Replace with the actual sessionId value

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Upcoming Sessions'),
          SizedBox(height: 20),
          Text('Previous Session Reports'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Pass the sessionId as an argument when navigating
              Navigator.pushNamed(
                context,
                '/session-results',
                arguments: sessionId,  // Passing the sessionId
              );
            },
            child: Text('View Session Report'),
          ),
        ],
      ),
    );
  }
}
