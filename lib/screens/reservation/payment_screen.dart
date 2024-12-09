import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Please proceed with your payment.',
              style: TextStyle(fontSize: 18),
            ),
            // You can add payment options like card details or a payment gateway here
            ElevatedButton(
              onPressed: () {
                // Proceed with payment logic
                // After successful payment, navigate to a confirmation screen or back to the dashboard
                Navigator.pushNamed(context, '/dashboard');
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
