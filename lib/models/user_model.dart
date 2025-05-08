class User {
  final String id;
  final String email;
  final String username;
  final String phone;
  final String? profileImage;
  final String? membershipType;
  final DateTime joinDate;
  final bool newcomer;
  final int sessionBalance;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    this.profileImage,
    this.membershipType,
    required this.joinDate,
    required this.newcomer,
    required this.sessionBalance,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? phone,
    String? profileImage,
    String? membershipType,
    DateTime? joinDate,
    bool? newcomer,
    int? sessionBalance,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      membershipType: membershipType ?? this.membershipType,
      joinDate: joinDate ?? this.joinDate,
      newcomer: newcomer ?? this.newcomer,
      sessionBalance: sessionBalance ?? this.sessionBalance,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      username: (json['username'] != null && json['username'].toString().trim().isNotEmpty)
          ? json['username']
          : 'Guest',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'],
      membershipType: json['membershipType'],
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      newcomer: json['newcomer'] ?? false,
      sessionBalance: json['sessionBalance'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'username': username,
      'phone': phone,
      'profileImage': profileImage,
      'membershipType': membershipType,
      'joinDate': joinDate.toIso8601String(),
      'newcomer': newcomer,
      'sessionBalance': sessionBalance,
    };
  }

  factory User.defaultUser() {
    return User(
      id: '0',
      email: 'guest@a.com',
      username: 'Guest',
      phone: '9631201963',
      profileImage: 'assets/images/logo.png',
      membershipType: 'basic',
      joinDate: DateTime.now(),
      newcomer: true,
      sessionBalance: 0,
    );
  }
  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, phone: $phone, newcomer: $newcomer, sessionBalance: $sessionBalance)';
  }
}
