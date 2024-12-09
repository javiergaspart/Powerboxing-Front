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
  Session? _selectedSession;
  int _selectedSlotIndex = -1;
  List<DateTime> _availableSlots = [];

  void _generateAvailableSlots() {
    _availableSlots = [];
    DateTime now = DateTime.now();

    // Determine the start time based on the selected date
    DateTime startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      9,
      0,
    );

    // If the selected date is today, start from the current time rounded to the nearest 30 minutes
    if (_selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day) {
      if (now.hour < 9 || (now.hour == 9 && now.minute == 0)) {
        startTime = DateTime(now.year, now.month, now.day, 9, 0); // Start from 9 AM
      } else {
        int minutes = now.minute;
        int roundedMinutes = (minutes % 30 == 0)
            ? minutes
            : (minutes ~/ 30 + 1) * 30;
        startTime = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
      }

      // Ensure the start time does not go past 6 PM
      if (startTime.hour >= 18) {
        _availableSlots = [];
        return; // No slots available for the rest of the day
      }
    }

    // End time is always 6 PM
    DateTime endTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      18,
      0,
    );

    // Generate slots in 30-minute intervals starting from 9 AM to 6 PM
    while (startTime.isBefore(endTime)) {
      // Only add slots from the current time or later
      if (_selectedDate.year == now.year &&
          _selectedDate.month == now.month &&
          _selectedDate.day == now.day) {
        if (startTime.isAfter(now)) {
          _availableSlots.add(startTime);
        }
      } else {
        _availableSlots.add(startTime);
      }

      startTime = startTime.add(Duration(minutes: 30));
    }
  }



  Future<void> _bookReservation(String location) async {
    if (_selectedSlotIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a time slot first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch the user from the provider
      final user = Provider.of<user_provider.UserProvider>(context, listen: false).user;
      print("user");
      if(user!=null){
        print("not null");
        print(user.id);
      }

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user logged in!')),
        );
        return; // Stop execution if user is null
      }

      // Convert selected date to string in the required format (e.g., "2024-12-10")
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      String slotTiming = DateFormat.jm().format(_availableSlots[_selectedSlotIndex]);

      // Proceed with booking using the new service function
      String userId = user.id.toString();
      print(userId);
      bool success = await _reservationService.reserveOrCreateSession(
        userId: userId,
        slotTimings: slotTiming,
        location: location,
        date: formattedDate,
        instructor: 'Default Instructor',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create reservation')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create reservation: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      appBar: AppBar(title: Text('Reserve a Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select a session to reserve',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Select Date:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(30, (index) {
                  DateTime date = DateTime.now().add(Duration(days: index));
                  bool isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _generateAvailableSlots();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            DateFormat('MMM d').format(date),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 16),
            Text('Available Time Slots:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _availableSlots.length,
                itemBuilder: (context, index) {
                  final slot = _availableSlots[index];
                  return ListTile(
                    title: Text(DateFormat.jm().format(slot)),
                    trailing: _selectedSlotIndex == index
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedSlotIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Location'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Select a location for the session:'),
                          DropdownButton<String>(
                            value: 'Hyderabad',
                            onChanged: (value) {
                              if (value != null) {
                                _bookReservation(value);
                                Navigator.pop(context);
                              }
                            },
                            items: ['Hyderabad'].map((location) {
                              return DropdownMenuItem<String>(
                                value: location,
                                child: Text(location),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _bookReservation('Hyderabad');
                              Navigator.pop(context);
                            },
                            child: Text('Book Reservation'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Proceed to Book'),
            ),
          ],
        ),
      ),
    );
  }
}
