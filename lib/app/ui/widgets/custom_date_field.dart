import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import '../../utils/date_utils.dart';

/// Generic tap-to-pick date field, styled to match [CustomTextField] so
/// date inputs look consistent with every other field in the app.
class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;
  final bool enabled;

  const CustomDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onDateSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.subHeading),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: !enabled ? null : () => _pickDate(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: enabled ? Colors.white : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppDateUtils.format(date), style: AppTextStyles.body),
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDateSelected(picked);
  }
}
