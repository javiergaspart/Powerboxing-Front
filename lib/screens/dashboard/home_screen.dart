import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../models/session_model.dart';
import '../../models/user_model.dart';
import 'package:intl/intl.dart';
import '../../styles/styles.dart';
import './reservation_screen.dart';
import '../navbar/settings_screen.dart';
import '../navbar/my_profile_screen.dart';
import '../navbar/contact_us_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Future<List<Session>> _upcomingSessions;
  late Future<List<Session>> _previousSessions;
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<Offset> _sidebarAnimation;
  bool _isSidebarOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _upcomingSessions = SessionService().getUpcomingSessions(widget.user.id);
    _previousSessions = SessionService().getPreviousSessions(widget.user.id);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _sidebarAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

<<<<<<< HEAD
  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
      if (_isSidebarOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _navigateToPage(String page) {
    print("Navigating to: $page");
    // Add your navigation logic here.
  }

=======
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

>>>>>>> 0d971ea886a46c4c8adca327e22306e9078b47e5
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A3D2D),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5DC),
        title: Row(
          children: [
<<<<<<< HEAD
            Image.asset('assets/images/logo.png', height: 40),
            SizedBox(width: 10),
            Text(
              'Powerboxing',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: _toggleSidebar,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // User Profile Row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle profile photo change
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          shape: BoxShape.rectangle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset('assets/images/profile_photo.jpg', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
                        ),
                        child: Text(
                          widget.user.username.toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // TabBar Header
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Summary'),
                  Tab(text: 'Previous Sessions'),
=======
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
>>>>>>> 0d971ea886a46c4c8adca327e22306e9078b47e5
                ],
                labelColor: Colors.white,
                indicatorColor: Colors.white,
              ),
<<<<<<< HEAD
              // TabBarView with cards at the top in Summary tab
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FutureBuilder<List<Session>>(
                      future: _upcomingSessions,
                      builder: (context, snapshot) {
                        String nextSession = 'None';
                        String sessionDate = '';
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          nextSession = snapshot.data![0].location;
                          sessionDate = DateFormat('yyyy-MM-dd').format(snapshot.data![0].date);
                        }
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildCard('Next Session: $nextSession', sessionDate, 'Reserve Session'),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: _buildCard('Available Sessions: 0', '', 'Become a Member'),
                                    ),
                                  ],
                                ),
                                // Future rows can be added here later
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Center(child: Text('Previous Sessions Placeholder', style: TextStyle(color: Colors.white))),
                  ],
                ),
=======
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
>>>>>>> 0d971ea886a46c4c8adca327e22306e9078b47e5
              ),
              // Footer
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('© 2025 Powerboxing. All rights reserved.', style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 5),
                      Text('www.powerboxing.fun', style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 5),
                      Text('Javier Gaspert', style: TextStyle(color: Colors.black54)),
                      SizedBox(height: 5),
                      Text('info@powerboxing.com', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sidebar
          SlideTransition(
            position: _sidebarAnimation,
            child: Container(
              width: 250,
              color: Color(0xFFF5F5DC),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 175,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF0A3D2D), width: 2)),
                    ),
                    child: TextButton(
                      onPressed: () => _navigateToPage('Profile'),
                      child: Text(
                        'Profile',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Color(0xFF0A3D2D)),
                      ),
                    ),
                  ),
                  Container(
                    width: 175,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF0A3D2D), width: 2)),
                    ),
                    child: TextButton(
                      onPressed: () => _navigateToPage('Payments'),
                      child: Text(
                        'Payments',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Color(0xFF0A3D2D)),
                      ),
<<<<<<< HEAD
                    ),
                  ),
                  Container(
                    width: 175,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF0A3D2D), width: 2)),
                    ),
                    child: TextButton(
                      onPressed: () => _navigateToPage('Contact Us'),
                      child: Text(
                        'Help',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Color(0xFF0A3D2D)),
=======
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
>>>>>>> 0d971ea886a46c4c8adca327e22306e9078b47e5
                      ),
                    ),
                  ),
                  Container(
                    width: 175,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFF0A3D2D), width: 2)),
                    ),
                    child: TextButton(
                      onPressed: () => _navigateToPage('Settings'),
                      child: Text(
                        'Settings',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Color(0xFF0A3D2D)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, String buttonText) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = width * 1.25; // Maintain aspect ratio of 1.25

        return Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5DC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(color: Colors.black)),
              if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(color: Colors.black)),
              SizedBox(height: 3),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF0A3D2D)),
                ),
                child: Text(buttonText, style: TextStyle(color: Color(0xFF0A3D2D))),
              ),
            ],
          ),
        );
      },
    );
  }
}
