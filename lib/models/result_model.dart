class PunchResult {
  final String id;
  final String sessionId;
  final String userId;
  final String username;
  final int accuracy;
  final int power;

  PunchResult({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.username,
    required this.accuracy,
    required this.power,
  });

  factory PunchResult.fromJson(Map<String, dynamic> json) {
    return PunchResult(
      id: json['id'] ?? '',  // Ensure non-null String
      sessionId: json['sessionId'] ?? '', // Ensure non-null String
      userId: json['userId'] ?? '', // Ensure non-null String
      username: json['username'] ?? '', // Ensure non-null String
      accuracy: json['accuracy'] ?? 0, // Ensure non-null Int
      power: json['power'] ?? 0, // Ensure non-null Int
    );
  }
}
