import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/reservation_service.dart';
import '../../models/session_model.dart';
import '../../providers/user_provider.dart' as user_provider;
import 'reservation_successful_screen.dart';

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

  void _generateAvailableSlots() {
    _availableSlots = [];
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 9, 0);
    if (_selectedDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      int roundedMinutes = now.minute % 30 == 0 ? now.minute : (now.minute ~/ 30 + 1) * 30;
      startTime = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
      if (startTime.hour >= 18) return;
    }
    DateTime endTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 18, 0);
    while (startTime.isBefore(endTime)) {
      if (_selectedDate.isAfter(now) || startTime.isAfter(now)) {
        _availableSlots.add(startTime);
      }
      startTime = startTime.add(Duration(minutes: 30));
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
        userId: user.id.toString(),
        slotTimings: slotTiming,
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
    _generateAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
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
                        _generateAvailableSlots();
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
                    onTap: () => setState(() => _selectedSlotIndex = index),
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
