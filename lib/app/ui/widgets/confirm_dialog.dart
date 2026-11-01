import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'custom_button.dart';

/// Reusable confirmation popup (uses GetX's dialog navigation) shown before
/// any destructive action such as deleting a group or a participant.
class ConfirmDialog {
  ConfirmDialog._();

  static Future<bool> show({
    required String title,
    required String message,
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
  }) async {
    final result = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.heading),
              const SizedBox(height: 10),
              Text(message, style: AppTextStyles.body),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: cancelLabel,
                      type: ButtonType.outline,
                      onPressed: () => Get.back(result: false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      label: confirmLabel,
                      type: ButtonType.danger,
                      onPressed: () => Get.back(result: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }
}
