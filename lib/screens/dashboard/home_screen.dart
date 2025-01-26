import 'package:fitboxing_app/screens/navbar/about_us_screen.dart';
import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../models/session_model.dart';
import '../../screens/session_result_screen.dart';
import './reservation_screen.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../navbar/membership_screen.dart';
import '../navbar/my_profile_screen.dart';
import '../navbar/contact_us_screen.dart';
import '../navbar/settings_screen.dart';
import '../../styles/styles.dart'; // Import the styles file

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Session>> _upcomingSessions;
  late Future<List<Session>> _previousSessions;

  @override
  void initState() {
    super.initState();
    _upcomingSessions = SessionService().getUpcomingSessions(widget.user.id);
    _previousSessions = SessionService().getPreviousSessions(widget.user.id);
  }

  void _handleMenuItemSelected(String value) {
    switch (value) {
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyProfileScreen(user: widget.user)),
        );
        break;
      case 'about':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutUsScreen()),
        );
        break;
      case 'membership':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MembershipScreen()),
        );
        break;
      case 'contact':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactUsScreen()),
        );
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
      case 'logout':
        Navigator.popUntil(context, ModalRoute.withName('/'));
        print("Logged out");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradients.backgroundGradient, // Use gradient from styles file
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Photo with dark grey border
                      Container(
                        width: 100,
                        height: 100,
                        decoration: AppImageStyles.profileImageDecoration(
                          hasProfileImage: widget.user.profileImage != null && widget.user.profileImage!.isNotEmpty,
                          profileImageUrl: widget.user.profileImage ?? '',
                        ),
                      ),
                      SizedBox(width: 8),
                      // Welcome Text with Session Balance
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.username,
                            style: AppTextStyles.welcomeText.copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Available Sessions: ${widget.user.sessionBalance}',
                            style: AppTextStyles.sectionTitle.copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Shortcut Navbar (3 horizontal lines icon)
                  PopupMenuButton<String>(
                    onSelected: _handleMenuItemSelected,
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'profile', child: Text('My Profile')),
                      PopupMenuItem(value: 'about', child: Text('About Us')),
                      PopupMenuItem(value: 'membership', child: Text('Membership')),
                      PopupMenuItem(value: 'contact', child: Text('Contact Us')),
                      PopupMenuItem(value: 'settings', child: Text('Settings')),
                      PopupMenuItem(value: 'logout', child: Text('Log Out')),
                    ],
                    icon: Icon(Icons.menu),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (widget.user.sessionBalance > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No available sessions. Please purchase more.')),
                    );
                  }
                },
                child: Text('Reserve Session'),
              ),
            ),
            FutureBuilder<List<Session>>(
              future: _upcomingSessions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final sessions = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Upcoming Sessions',
                          style: AppTextStyles.sectionTitle,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return ListTile(
                            title: Text(session.location),
                            subtitle: Text(DateFormat('yyyy-MM-dd').format(session.date)),
                            trailing: Text(session.status),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SessionResultScreen(sessionId: session.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('No upcoming sessions found.'));
                }
              },
            ),
            FutureBuilder<List<Session>>(
              future: _previousSessions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final sessions = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Previous Sessions',
                          style: AppTextStyles.sectionTitle,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return ListTile(
                            title: Text(session.location),
                            subtitle: Text(DateFormat('yyyy-MM-dd').format(session.date)),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SessionResultScreen(sessionId: session.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('No previous sessions found.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
