import 'dart:convert';

class Session {
  final String id;
  final DateTime date; // Changed from String to DateTime
  final String slotTimings;
  final String location;
  final String instructor;
  final List<String> bookedUsers;
  final List<String> punchingBags;
  final bool isCompleted;
  final String time;
  final String username;
  final DateTime createdAt;
  int availableSlots; // Changed to non-final to allow decrementing
  final int totalSlots;

  Session({
    required this.id,
    required this.date,
    required this.slotTimings,
    required this.location,
    required this.instructor,
    required this.bookedUsers,
    required this.punchingBags,
    required this.isCompleted,
    required this.time,
    required this.username,
    required this.createdAt,
    required this.availableSlots,
    required this.totalSlots,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    print("Raw session JSON: $json");

    return Session(
      id: json['_id'] ?? '',
      date: DateTime.parse(json['date']),
      slotTimings: json['slotTiming'] ?? '',
      location: json['location'] ?? '',
      instructor: json['instructor'] ?? '',
      bookedUsers: (json['bookedUsers'] as List)
          .map((user) => user['username'].toString()) // Extract usernames
          .toList(),
      punchingBags: List<String>.from(json['punchingBags'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
      time: json['slotTimings'] ?? '',
      username: json['username'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      availableSlots: json['availableSlots'] ?? 0,
      totalSlots: json['totalSlots'] ?? 0,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(), // Fix: Convert DateTime to String
      'slotTimings': slotTimings,
      'location': location,
      'instructor': instructor,
      'bookedUsers': bookedUsers,
      'punchingBags': punchingBags,
      'createdAt': createdAt.toIso8601String(),
      'availableSlots': availableSlots,
      'totalSlots': totalSlots,
    };
  }

  // Fix: Getter for session status
  String get status {
    final now = DateTime.now();
    return date.isAfter(now) ? "Upcoming" : "Past";
  }

  // Fix: Setter for decrementing availableSlots
  void reserveSlot(String userId) {
    if (availableSlots > 0) {
      bookedUsers.add(userId);
      availableSlots--; // Now works because it's not final
    }
  }
  Session.empty()
      : id = '',
        date = DateTime.now(),
        slotTimings = '',
        location = '',
        instructor = '',
        bookedUsers = [],
        punchingBags = [],
        isCompleted = false,
        time = '',
        username = '',
        createdAt = DateTime.now(),
        availableSlots = 0,
        totalSlots = 0;
}
