import 'package:flutter/material.dart';

// User model representing the customer details
class UserModel {
  final String id;
  final String email;
  final String username;
  final String phone;
  final String? profileImage; // Nullable
  final String? membershipType; // Nullable
  final DateTime joinDate;
  final bool newcomer;
  final int sessionBalance; // Added session balance

  UserModel({
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

  // Convert JSON to User object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? '',
      membershipType: json['membershipType'] ?? 'basic',
      joinDate: DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      newcomer: json['newcomer'] ?? false,
      sessionBalance: json['sessionBalance'] ?? 1, // Default to 1 session for newcomers
    );
  }

  // Convert User object to JSON
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
}

// User provider to manage current user
class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Function to update session balance after booking a session
  void decrementSessionBalance() {
    if (_user != null && _user!.sessionBalance > 0) {
      _user = UserModel(
        id: _user!.id,
        email: _user!.email,
        username: _user!.username,
        phone: _user!.phone,
        profileImage: _user!.profileImage,
        membershipType: _user!.membershipType,
        joinDate: _user!.joinDate,
        newcomer: _user!.newcomer,
        sessionBalance: _user!.sessionBalance - 1,
      );
      notifyListeners();
    }
  }
}
