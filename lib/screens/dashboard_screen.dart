import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitboxing_app/models/user_model.dart';  // Import the User model
import 'package:fitboxing_app/screens/dashboard/reservation_screen.dart';
import 'package:fitboxing_app/screens/membership_screen.dart';
import 'package:fitboxing_app/screens/dashboard/home_screen.dart'; // HomeScreen with required 'user' parameter
import 'package:fitboxing_app/providers/user_provider.dart' as user_provider;  // Alias UserProvider import

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the user from the UserProvider
    User? user = Provider.of<user_provider.UserProvider>(context).user;  // Use the alias here

    if (user == null) {
      // Handle the case where user is not available
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: TabBarView(
        children: [
          // Pass the user to the HomeScreen
          HomeScreen(user: user),
          ReservationScreen(),
          MembershipScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Reserve'),
          BottomNavigationBarItem(icon: Icon(Icons.card_membership), label: 'Membership'),
        ],
      ),
    );
  }
}
