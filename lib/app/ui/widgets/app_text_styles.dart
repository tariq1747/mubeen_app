import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Single source of truth for every text style used across the app.
class AppTextStyles {
  AppTextStyles._();

  static const heading = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const subHeading = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const body = TextStyle(fontSize: 14, color: AppColors.textPrimary);
  static const caption = TextStyle(fontSize: 12, color: AppColors.textSecondary);
  static const button = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white);
}
