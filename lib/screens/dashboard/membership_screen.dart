import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fitboxing_app/providers/user_provider.dart';
import 'package:fitboxing_app/services/membership_service.dart';
import '../../constants/urls.dart';
import './home_screen.dart';

class MembershipScreen extends StatefulWidget {
  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final MembershipService membershipService = MembershipService();
  late Razorpay _razorpay;
  int _currentSessionsBought = 0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _purchaseSessions(BuildContext context, int sessionsBought) async {
    _currentSessionsBought = sessionsBought;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id ?? '';

    final priceMap = {
      1: 600,
      5: 2500,
      10: 4000,
      20: 7000,
    };

    final amount = priceMap[sessionsBought] ?? 0;
    print("Starting payment for $sessionsBought sessions. Amount: $amount");

    try {
      final response = await http.post(
        Uri.parse('${AppUrls.baseUrl}/payments/create-order'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount}),
      );

      print('Backend response status: ${response.statusCode}');
      print('Backend response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        var options = {
          'key': data['key'],
          'amount': data['amount'],
          'currency': data['currency'],
          'order_id': data['orderId'],
          'name': 'FitBoxing Membership',
          'description': '$sessionsBought sessions',
          'prefill': {
            'contact': userProvider.user?.phone ?? '',
            'email': userProvider.user?.email ?? '',
          }
        };

        print('Opening Razorpay with options: $options');

        _razorpay.open(options);
      } else {
        throw Exception("Failed to create order");
      }
    } catch (e) {
      print('Exception during payment start: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed to start: $e")),
      );
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final res = await http.post(
        Uri.parse('http://<your-server-url>/api/payments/verify-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_order_id': response.orderId,
          'razorpay_payment_id': response.paymentId,
          'razorpay_signature': response.signature,
        }),
      );

      if (res.statusCode == 200) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateSessionBalance(_currentSessionsBought);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment successful! Sessions added.")),
        );
      } else {
        throw Exception("Payment verification failed");
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error verifying payment: $err")),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed with code: ${response.code}");
    print("Message: ${response.message}");
    // You can also show a snackbar or dialog here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Membership',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(user: Provider.of<UserProvider>(context, listen: false).user),
                ),
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/box2.jpg', fit: BoxFit.cover),
              SizedBox(height: 16),
              Text(
                'Increase your training with session packs',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildMembershipCard(context, 20, '350 INR/session', '₹ 7000'),
                  _buildMembershipCard(context, 10, '400 INR/session', '₹ 4000'),
                  _buildMembershipCard(context, 5, '500 INR/session', '₹ 2500'),
                  _buildMembershipCard(context, 1, '600 INR/session', '₹ 600'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, int sessions, String pricePerSession, String totalPrice) {
    return GestureDetector(
      onTap: () => _purchaseSessions(context, sessions),
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Color(0xFF242424), Color(0xFF636363)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF5A5858),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$sessions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto Condensed',
              ),
            ),
            SizedBox(height: 5),
            Text(
              pricePerSession,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              totalPrice,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
