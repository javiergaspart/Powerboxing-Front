class Reservation {
  final String id;
  final String userId;
  final String sessionId;
  final String status; // 'booked', 'completed', 'canceled'
  final DateTime reservationDate;

  Reservation({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.status,
    required this.reservationDate,
  });

  // Convert JSON to Reservation object
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['_id'],
      userId: json['userId'],
      sessionId: json['sessionId'],
      status: json['status'],
      reservationDate: DateTime.parse(json['reservationDate']),
    );
  }

  // Convert Reservation object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'sessionId': sessionId,
      'status': status,
      'reservationDate': reservationDate.toIso8601String(),
    };
  }
}
