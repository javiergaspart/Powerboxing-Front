import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class BookSessionScreen extends StatefulWidget {
  final String token;

  BookSessionScreen({required this.token});

  @override
  _BookSessionScreenState createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  List<DateTime> week1 = [];
  List<DateTime> week2 = [];
  Map<String, List<String>> availableSessions = {};
  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _generateNextTwoWeeks();
  }

  /// ✅ Generate two weeks of dates (first week includes only future days)
  void _generateNextTwoWeeks() {
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime day = today.add(Duration(days: i));
      week1.add(day);
    }
    for (int i = 7; i < 14; i++) {
      week2.add(today.add(Duration(days: i)));
    }
    setState(() {});
  }

  /// ✅ Fetch available sessions for a given date
  Future<void> _fetchAvailableSessions(String date) async {
    setState(() => selectedDate = date);

    final response = await http.get(
      Uri.parse("http://localhost:10000/api/sessions?date=$date"),
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        availableSessions[date] = List<String>.from(data["sessions"]);
      });
    } else {
      print("❌ Failed to fetch sessions: ${response.body}");
    }
  }

  /// ✅ Book a session
  Future<void> _bookSession(String time) async {
    final response = await http.post(
      Uri.parse("http://localhost:10000/api/book-session"),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'date': selectedDate, 'time': time}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Session booked successfully!")),
      );
      _fetchAvailableSessions(selectedDate); // Refresh available sessions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to book session.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Book a Session"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Week 1"),
              Tab(text: "Week 2"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildWeekTab(week1),
            _buildWeekTab(week2),
          ],
        ),
      ),
    );
  }

  /// ✅ Build UI for a week tab
  Widget _buildWeekTab(List<DateTime> week) {
    return ListView.builder(
      itemCount: week.length,
      itemBuilder: (context, index) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(week[index]);
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text(DateFormat('EEEE, MMM d').format(week[index])),
            onExpansionChanged: (expanded) {
              if (expanded && !availableSessions.containsKey(formattedDate)) {
                _fetchAvailableSessions(formattedDate);
              }
            },
            children: _buildSessionList(formattedDate),
          ),
        );
      },
    );
  }

  /// ✅ Display available sessions for a date
  List<Widget> _buildSessionList(String date) {
    if (!availableSessions.containsKey(date)) {
      return [Padding(padding: EdgeInsets.all(10), child: Text("Loading..."))];
    }
    if (availableSessions[date]!.isEmpty) {
      return [Padding(padding: EdgeInsets.all(10), child: Text("No available sessions."))];
    }
    return availableSessions[date]!.map((time) {
      return ListTile(
        title: Text("⏰ $time"),
        trailing: ElevatedButton(
          onPressed: () => _bookSession(time),
          child: Text("Book"),
        ),
      );
    }).toList();
  }
}
