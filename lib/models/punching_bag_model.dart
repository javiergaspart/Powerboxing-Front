class PunchingBag {
  final String id;            // Unique identifier for the punching bag
  final String sessionId;     // ID of the session this punching bag belongs to
  final String status;        // Status of the punching bag (available, in-use, etc.)
  final double maxForce;      // Maximum force capacity of the punching bag (in kg or pounds)
  final int currentPunches;   // The number of punches registered by the bag in the current session
  final String sensorId;      // ID of the sensor connected to the punching bag
  final String location;      // The location of the punching bag within the session (e.g., row 1, position 2)

  PunchingBag({
    required this.id,
    required this.sessionId,
    required this.status,
    required this.maxForce,
    required this.currentPunches,
    required this.sensorId,
    required this.location,
  });

  // Convert JSON to PunchingBag object
  factory PunchingBag.fromJson(Map<String, dynamic> json) {
    return PunchingBag(
      id: json['_id'],
      sessionId: json['sessionId'],
      status: json['status'],  // Status could be 'available', 'assigned', 'in-use'
      maxForce: json['maxForce'].toDouble(),
      currentPunches: json['currentPunches'],
      sensorId: json['sensorId'],
      location: json['location'],
    );
  }

  // Convert PunchingBag object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sessionId': sessionId,
      'status': status,
      'maxForce': maxForce,
      'currentPunches': currentPunches,
      'sensorId': sensorId,
      'location': location,
    };
  }
}
