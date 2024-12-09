import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
  final String sessionName;
  final String sessionTime;
  final String location;
  final bool isAvailable;
  final VoidCallback onBookNow;

  SessionCard({
    required this.sessionName,
    required this.sessionTime,
    required this.location,
    required this.isAvailable,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Icon
            Icon(
              Icons.fitness_center,
              color: Colors.blue,
              size: 40.0,
            ),
            SizedBox(width: 16.0),
            // Session Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionName,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Time: $sessionTime',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Location: $location',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: isAvailable ? onBookNow : null,
                    child: Text(isAvailable ? 'Book Now' : 'Full'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          isAvailable ? Colors.blue : Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
