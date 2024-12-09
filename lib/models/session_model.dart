class Session {
  final String id;
  final String location;
  final DateTime date;
  final String slotTimings; // Added to match backend
  final String instructor;
  final List<String> bookedUsers; // User IDs for booked users
  final List<String> punchingBags; // IDs for punching bags
  final DateTime createdAt; // Session creation timestamp
  int availableSlots; // Made mutable by removing 'final'
  final int totalSlots; // Kept as 'final' since it is not modified

  Session({
    required this.id,
    required this.location,
    required this.date,
    required this.slotTimings,
    required this.instructor,
    required this.bookedUsers,
    required this.punchingBags,
    required this.createdAt,
    this.availableSlots = 0,
    this.totalSlots = 20, // Default total slots
  });

  // Convert JSON to Session object
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['_id'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      slotTimings: json['slotTimings'],
      instructor: json['instructor'] ?? 'Unknown Instructor',
      bookedUsers: json['bookedUsers'] != null
          ? (json['bookedUsers'] as List)
          .map((user) => user['_id'] as String) // Extract user IDs
          .toList()
          : [],
      punchingBags: List<String>.from(json['punchingBags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      availableSlots: json.containsKey('bookedUsers')
          ? (20 - (json['bookedUsers']?.length ?? 0)).toInt() // Explicit cast
          : 20,
      totalSlots: 20, // Default as backend doesn't specify total slots
    );
  }



  // Convert Session object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'location': location,
      'date': date.toIso8601String(),
      'slotTimings': slotTimings,
      'instructor': instructor,
      'bookedUsers': bookedUsers,
      'punchingBags': punchingBags,
      'createdAt': createdAt.toIso8601String(),
      'availableSlots': availableSlots,
      'totalSlots': totalSlots,
    };
  }

  // Getter for session status
  String get status {
    final now = DateTime.now();
    return date.isAfter(now) ? "Upcoming" : "Past";
  }

  // Check if the session has available slots
  bool get isAvailable {
    return availableSlots > 0;
  }

  // Reserve a slot (used when a user books a session)
  void reserveSlot(String userId) {
    if (isAvailable) {
      bookedUsers.add(userId);
      availableSlots--; // Now this will work
    }
  }
}
