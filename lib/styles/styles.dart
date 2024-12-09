import 'package:flutter/material.dart';

// Define text styles
class AppTextStyles {
  static const TextStyle welcomeText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle emailText = TextStyle(
    fontSize: 18,
  );
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

// Define gradient for the background
class AppGradients {
  static LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.grey[300]!, Colors.grey[800]!],
  );
}

// Define image styles
class AppImageStyles {
  static BoxDecoration profileImageDecoration({
    required bool hasProfileImage,
    required String profileImageUrl,
  }) {
    return BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.grey[700]!, // Dark grey border
        width: 2,
      ),
      image: hasProfileImage
          ? DecorationImage(
        image: NetworkImage(profileImageUrl),
        fit: BoxFit.cover,
      )
          : null,
      color: hasProfileImage ? Colors.transparent : Colors.grey[200], // Default background if no image
    );
  }
}
