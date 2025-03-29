import 'package:flutter/material.dart';

import '../../features/settings/app_settings.dart';

class AppColors{
  AppColors._();

  // App Basic Colors
  static const Color primaryColor = AppSettings.primaryColor;
  static const Color secondaryColor = Color(0xFF2d2d2d);

  // Link color
  static const Color offerColor = Color(0xFF2BAA3A);
  static const Color linkColor = Colors.blue;
  static const Color refreshIndicator = Colors.blue;

  // Text Colors
  static const Color textColor = Color(0xFF2d2d2d);
  static const Color headlineColor = Color(0xFF2d2d2d);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkContainer = Colors.white;

  // Button Colors
  static const Color buttonTextColor = AppSettings.secondaryColor;
  static const Color buttonDisabled = Color(0xFFC4C4C4);
  static const Color buttonBorder = Colors.grey;
  static const Color buttonBackgroundColor = AppSettings.primaryColor;

  // Surface
  static const Color surface = Color(0xFFF6F6F6);
  static const Color onSurface = Color(0xFF272727);
  static const Color onSurfaceVariant = Color(0xFF0B1014);

  // Border Colors
  static const Color borderLight = Color(0xFFD9D9D9);
  static const Color borderDark = Color(0xFFE6E6E6);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF6F6F6);
  static const Color backgroundDark = Color(0xFF0B1014);

  // Star Rating
  static const Color ratingStar = Colors.orange;

  // Whatsapp color
  static const Color whatsAppColor = Color(0xFF25D366);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Gradient Colors
  static const Gradient linerGradient = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(0.707, -0.707),
    colors: [
     Color(0xFFFF9A9E),
     Color(0xFFFAD0C4),
     Color(0xFFFAD0C4)
  ]);

  // Method to get color based on string input
  static Color getColorFromString(String colorName) {
    Map<String, Color> colorMap = {
      'black': Colors.black,
      'white': Colors.white,
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'indigo': Colors.indigo,
      'cyan': Colors.cyan,
      'amber': Colors.amber,
      'teal': Colors.teal,
      'lime': Colors.lime,
      'deepPurple': Colors.deepPurple,
      'deepOrange': Colors.deepOrange,
      // Add more colors as needed
    };
    // Return the color from map, or a default color if not found
    return colorMap[colorName] ?? Colors.transparent;
  }

}