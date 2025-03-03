import 'package:flutter/material.dart';
import 'session_booking_screen.dart';
import 'session_history_screen.dart';
import 'leaderboard_screen.dart';

class BoxerDashboard extends StatefulWidget {
  @override
  _BoxerDashboardState createState() => _BoxerDashboardState();
}

class _BoxerDashboardState extends State<BoxerDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boxer Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Book Session"),
            Tab(text: "Session History"),
            Tab(text: "Leaderboard"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SessionBookingScreen(),
          SessionHistoryScreen(),
          LeaderboardScreen(),
        ],
      ),
    );
  }
}
