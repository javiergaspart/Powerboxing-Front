import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitboxing_app/providers/user_provider.dart';
import 'package:fitboxing_app/services/membership_service.dart';
import './home_screen.dart';

class MembershipScreen extends StatelessWidget {
  final MembershipService membershipService = MembershipService();

  void _purchaseSessions(BuildContext context, int sessionsBought) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id ?? ''; // Use null-check and provide a fallback

    try {
      await membershipService.purchaseSessions(userId, sessionsBought);
      userProvider.updateSessionBalance(sessionsBought);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully purchased $sessionsBought sessions!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error purchasing sessions: $error')),
      );
    }
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
