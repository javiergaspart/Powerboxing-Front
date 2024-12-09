import 'package:flutter/material.dart';

// User model as provided
class User {
  final String id;
  final String email;
  final String username;
  final String? contact;
  final String? profileImage; // Nullable
  final String? membershipType; // Nullable

  User({
    required this.id,
    required this.email,
    required this.username,
    this.contact,
    this.profileImage,
    this.membershipType,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      contact: json['contact'] ?? '',
      profileImage: json['profileImage'] ?? '',
      membershipType: json['membershipType'] ?? 'basic',
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'username': username,
      'contact': contact,
      'profileImage': profileImage,
      'membershipType': membershipType,
    };
  }
}

// User provider to manage current user
class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
