// lib/utils/validators.dart

class Validators {
  // Email validation using regex
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  // Phone number validation using regex
  static bool isValidPhone(String phone) {
    final phoneRegExp = RegExp(r'^\+?[1-9]\d{1,14}$');  // Example for international phone numbers
    return phoneRegExp.hasMatch(phone);
  }
}
