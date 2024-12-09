import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;  // The current user object

  // Getter for the current user
  User? get user => _user;

  // Method to set the user, possibly after login
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();  // Notify listeners that the user data has changed
  }

  // Optionally, you can add a method to clear user data when logging out
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
