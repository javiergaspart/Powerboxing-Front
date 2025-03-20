import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../models/session_model.dart';
import '../../models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:fitboxing_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import '../../styles/styles.dart';
import './reservation_screen.dart';
import '../auth/login_screen.dart';
import '../navbar/my_profile_screen.dart';
import '../navbar/contact_us_screen.dart';
import '../navbar/membership_screen.dart';
import './results_screen.dart';
import './settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Future<List<Session>> _upcomingSessions;
  late Future<List<Session>> _previousSessions;
  late TabController _tabController;
  bool _isPopupOpen = false;
  int _selectedIndex = 0; // Track the selected tab

  late final List<Widget> _screens; // Declare without initializing

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Change selected index when tapped
    });
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),  // Pass user parameter
      SettingsScreen(),  // Settings Screen
      MyProfileScreen(user: widget.user!),
    ];
    _tabController = TabController(length: 2, vsync: this);
    final userId = widget.user?.id;
    _upcomingSessions =
    userId != null ? SessionService().getUpcomingSessions(userId) : Future
        .value([]);
    _previousSessions =
    userId != null ? SessionService().getPreviousSessions(userId) : Future
        .value([]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String getFirstName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return "Guest";
    return fullName.split(" ").first; // Splitting at the first space
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final updatedUser = userProvider.user ?? User.defaultUser(); // Ensure user is never null
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildScreen(updatedUser),  // Display the selected screen
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeContent(User updatedUser) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                      "WELCOME BACK, ${getFirstName(updatedUser?.username).toUpperCase() ?? 'GUEST'}!",
                      style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'RobotoCondensed',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2C2C2C),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildChallengeCard(),
            const SizedBox(height: 20),
            _buildSessionSection("Previous Sessions", _previousSessions, context),
            const SizedBox(height: 60),
            _buildSessionSection("Upcoming Sessions", _upcomingSessions, context),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReservationScreen()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Color(0xFF280D36), Color(0xFF480876)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Reserve Session",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildAchievementsSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF151718),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF24292A),
            offset: Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.3),
              BlendMode.modulate,
            ),
            child: Image.asset(
                'assets/images/sessions.jpeg', width: double.infinity,
                height: 100,
                fit: BoxFit.cover),
          ),
          SizedBox(height: 10),
          Text(session.location, style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(DateFormat('dd MMM, yyyy').format(session.date),
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          Text("Instructor: ${session.instructor}",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildChallengeCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF280D36), Color(0xFF480876)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Today's Challenge",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionSection(String title, Future<List<Session>> sessions, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        FutureBuilder<List<Session>>(
          future: sessions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text("Error fetching sessions", style: TextStyle(color: Colors.red));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No sessions available", style: TextStyle(color: Colors.white));
            } else {
              return Column(
                children: snapshot.data!.map((session) {
                  return Container(
                    width: double.infinity, // Matches the width of today's challenge card
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151718),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF24292A),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/sessions.jpeg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.location,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                session.instructor,
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2C2C2C),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.timer, color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text("20 min", style: TextStyle(color: Colors.white, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2C2C2C),
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {
                                      final userProvider = Provider.of<UserProvider>(context, listen: false);
                                      final updatedUser = userProvider.user;
                                      String username = updatedUser?.username ?? "UNKNOWN USER";

                                      print("Navigating with username: $username");

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResultScreen(
                                            sessionId: session.id,
                                            location: session.location,
                                            date: DateFormat('yyyy-MM-dd').format(session.date),
                                            time: session.time,
                                            username: username,
                                            instructor: session.instructor,
                                            isCompleted: session.isCompleted,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Details",
                                      style: TextStyle(color: Color(0xFFA4D037), fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildReserveSessionSection() {
    return Text("Reserve Session", style: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildAchievementsSection() {
    return Text("Achievements", style: TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.white,
      currentIndex: _selectedIndex,  // Ensure the correct tab is highlighted
      onTap: _onItemTapped,  // Handle taps
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
  Widget _buildScreen(User updatedUser) {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(updatedUser);  // Provide a default user
      case 1:
        return SettingsScreen();
      case 2:
        return MyProfileScreen(user: widget.user ?? User.defaultUser());
      default:
        return HomeScreen(user: widget.user ?? User.defaultUser());
    }
  }

}
