import 'package:flutter/material.dart';

class MembershipWidget extends StatelessWidget {
  final String membershipType;
  final String benefits;
  final double price;

  MembershipWidget({
    required this.membershipType,
    required this.benefits,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Membership',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4.0,
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Membership Type: $membershipType',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Benefits: $benefits',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: \$${price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality to upgrade membership
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Upgrade Membership Clicked')),
                );
              },
              child: Text('Upgrade Membership'),
            ),
          ],
        ),
      ),
    );
  }
}
