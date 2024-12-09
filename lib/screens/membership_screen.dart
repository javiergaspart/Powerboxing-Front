import 'package:flutter/material.dart';
import '../models/membership.dart';
import '../services/membership_service.dart';

class MembershipScreen extends StatefulWidget {
  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final MembershipService _membershipService = MembershipService();
  List<Membership> _memberships = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMemberships();
  }

  // Fetch memberships from the service
  Future<void> _fetchMemberships() async {
    try {
      List<Membership> memberships = await _membershipService.getMemberships();
      setState(() {
        _memberships = memberships;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show an error message if the request fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load memberships')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Options'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : ListView.builder(
              itemCount: _memberships.length,
              itemBuilder: (context, index) {
                final membership = _memberships[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(membership.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(membership.description),
                        SizedBox(height: 8),
                        Text('Price: ₹${membership.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Duration: ${membership.durationMonths} months', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    onTap: () {
                      // Handle membership selection
                      _showMembershipDetails(membership);
                    },
                  ),
                );
              },
            ),
    );
  }

  // Display more details about a selected membership
  void _showMembershipDetails(Membership membership) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(membership.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${membership.description}'),
              SizedBox(height: 8),
              Text('Price: ₹${membership.price.toStringAsFixed(2)}'),
              Text('Duration: ${membership.durationMonths} months'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle payment or further actions
                Navigator.pop(context);
                // Example: Navigate to payment screen
              },
              child: Text('Subscribe'),
            ),
          ],
        );
      },
    );
  }
}
