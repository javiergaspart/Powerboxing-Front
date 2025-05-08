import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/reservation_service.dart';
import '../../models/session_model.dart';
import '../../providers/user_provider.dart' as user_provider;
import 'reservation_successful_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/urls.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _reservationService = ReservationService();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  int _selectedSlotIndex = -1;
  List<DateTime> _availableSlots = [];

  Future<void> _fetchAvailableSlots() async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final response = await http.get(
      Uri.parse('${AppUrls.baseUrl}/sessions/all-slots?date=$formattedDate'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        final rawSlots = data['data'];
        print("Fetched ${rawSlots.length} raw slots from API:");
        for (var slot in rawSlots) {
          print(" - ${slot['slotTiming']}");
        }

        final parsedSlots = List.generate(rawSlots.length, (index) {
          final timeStr = rawSlots[index]['slotTiming']
              .toString()
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
          final parts = timeStr.split(' ');
          final timeParts = parts[0].split(':');
          int hour = int.parse(timeParts[0]);
          int minute = int.parse(timeParts[1]);

          if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
          if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;

          final slotTime = DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            hour,
            minute,
          );

          print("Parsed slot: $timeStr → $slotTime");

          return slotTime;
        });

        // Check for duplicates
        final seen = <String>{};
        for (var dt in parsedSlots) {
          final iso = dt.toIso8601String();
          if (seen.contains(iso)) {
            print("⚠️ Duplicate found: $iso");
          } else {
            seen.add(iso);
          }
        }

        setState(() {
          _availableSlots = parsedSlots;
        });
      } else {
        setState(() {
          _availableSlots = [];
        });
        print("API returned success: false");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch slots')),
      );
      print("Failed to fetch slots. Status: ${response.statusCode}");
    }
  }



  Future<void> _bookReservation(String location) async {
    if (_selectedSlotIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a time slot first.')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final user = Provider.of<user_provider.UserProvider>(context, listen: false).user;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user logged in!')));
        return;
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String slotTiming = DateFormat.jm().format(_availableSlots[_selectedSlotIndex]);
      int totalSlots = 10;
      String sessionTime = slotTiming;

      bool success = await _reservationService.reserveOrCreateSession(
        context: context,
        userId: user.id.toString(),
        slotTiming: slotTiming,
        location: location,
        date: formattedDate,
        instructor: 'Default Instructor',
        totalSlots: totalSlots,
        time: sessionTime,
      );
      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationSuccessfulScreen(
              reservationDate: _availableSlots[_selectedSlotIndex],
              user: user,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create reservation')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create reservation: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<user_provider.UserProvider>(context, listen: false).user;
    int availableSessions = user?.sessionBalance ?? 0;

    return Scaffold(
      backgroundColor: Color(0xFF151718),
      appBar: AppBar(
        title: Text('Reserve a Session', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column( // Added 'child: Column()' to fix the error
          children: [
          Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Available Sessions: $availableSessions',
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  DateTime date = DateTime.now().add(Duration(days: index));
                  bool isSelected = _selectedDate.day == date.day &&
                      _selectedDate.month == date.month &&
                      _selectedDate.year == date.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _fetchAvailableSlots();
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF99C448) : Colors.transparent,
                        border: Border.all(color: isSelected ? Color(0xFF99C448) : Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${date.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _availableSlots.length,
                itemBuilder: (context, index) {
                  final slot = _availableSlots[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedSlotIndex = index);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedSlotIndex == index ? Color(0xFF99C448) : Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        DateFormat.jm().format(slot),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: (_selectedSlotIndex == -1) ? null : () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Confirm Reservation',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Location: Hyderabad',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Selected Slot: ${DateFormat.jm().format(_availableSlots[_selectedSlotIndex])}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _bookReservation('Hyderabad'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF99C448),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            ),
                            child: Text('Confirm', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF99C448)), // Ensures green color
                foregroundColor: MaterialStateProperty.all(Colors.white), // Ensures white text
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14, horizontal: 40)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              child: Text('Reserve',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
