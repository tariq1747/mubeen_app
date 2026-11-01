import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

enum ButtonType { primary, outline, danger }

/// Generic button used everywhere in the app so every screen shares the
/// exact same shape, spacing and color rules.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = _foregroundColor();

    final child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.button.copyWith(color: foreground),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor(),
          elevation: type == ButtonType.outline ? 0 : 1,
          side: type == ButtonType.outline ? const BorderSide(color: AppColors.primary) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        child: child,
      ),
    );
  }

  Color _backgroundColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.danger:
        return AppColors.danger;
      case ButtonType.outline:
        return Colors.transparent;
    }
  }

  Color _foregroundColor() {
    switch (type) {
      case ButtonType.outline:
        return AppColors.primary;
      default:
        return Colors.white;
    }
  }
}
