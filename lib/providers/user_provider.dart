import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;  // The current user object

  // Getter for the current user
  User? get user => _user;

  // Method to set the user, possibly after login
  void setUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();  // Notify listeners that the user data has changed
  }

  void updateSessionBalance(int newBalance) {
    if (_user != null) {
      _user = _user!.copyWith(sessionBalance: newBalance);
      notifyListeners();
    }
  }

  void logout() {
    _user = null; // Clear the user data
    notifyListeners();
  }

}
