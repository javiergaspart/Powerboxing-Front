class PunchResult {
  final String sessionId;
  final String userId;
  final int correctPunches;
  final int totalPunches;
  final double powerScore;
  final double accuracyScore;

  PunchResult({
    required this.sessionId,
    required this.userId,
    required this.correctPunches,
    required this.totalPunches,
    required this.powerScore,
    required this.accuracyScore,
  });

  // Convert JSON to PunchResult object
  factory PunchResult.fromJson(Map<String, dynamic> json) {
    return PunchResult(
      sessionId: json['sessionId'],
      userId: json['userId'],
      correctPunches: json['correctPunches'],
      totalPunches: json['totalPunches'],
      powerScore: json['powerScore'].toDouble(),
      accuracyScore: json['accuracyScore'].toDouble(),
    );
  }

  // Convert PunchResult object to JSON
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'correctPunches': correctPunches,
      'totalPunches': totalPunches,
      'powerScore': powerScore,
      'accuracyScore': accuracyScore,
    };
  }
}
