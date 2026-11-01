import 'package:flutter/material.dart';

/// Single source of truth for every color used across the app.
/// Never hard-code a Color elsewhere - add it here and reuse it.
class AppColors {
  AppColors._();

  static const primary = Color.fromARGB(255, 63, 181, 148);
  static const primaryDark = Color(0xFF303F9F);
  static const accent = Color(0xFF00BCD4);
  static const background = Color(0xFFF5F6FA);
  static const cardBackground = Colors.white;
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B6B8D);
  static const danger = Color(0xFFE53935);
  static const success = Color(0xFF43A047);
  static const warning = Color(0xFFFB8C00);
  static const border = Color(0xFFE0E0E0);

  static Color statusColor(String statusLabel) {
    switch (statusLabel) {
      case 'Start':
        return warning;
      case 'In Process':
        return primary;
      case 'Completed':
        return success;
      default:
        return textSecondary;
    }
  }
}
