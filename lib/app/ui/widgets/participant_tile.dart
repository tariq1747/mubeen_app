import 'package:flutter/material.dart';
import '../../data/models/participant_model.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import '../../utils/date_utils.dart';

/// Row showing one participant's details plus edit/delete actions.
/// Reused on the create-group, edit-group and group-details screens.
class ParticipantTile extends StatelessWidget {
  final ParticipantModel participant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ParticipantTile({
    super.key,
    required this.participant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(participant.name, style: AppTextStyles.subHeading),
                const SizedBox(height: 4),
                Text('Passport: ${participant.passportNumber}', style: AppTextStyles.caption),
                Text('Mobile: ${participant.mobileNumber}', style: AppTextStyles.caption),
                Text('Joined: ${AppDateUtils.format(participant.joiningDate)}', style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  'Total: \u20b9${participant.totalAmount.toStringAsFixed(0)}  \u2022  '
                  'Advance: \u20b9${participant.advanceAmount.toStringAsFixed(0)}  \u2022  '
                  'Final: \u20b9${participant.finalPaymentAmount.toStringAsFixed(0)}  \u2022  '
                  'Pending: \u20b9${participant.pendingAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit, color: AppColors.primary), onPressed: onEdit),
              IconButton(icon: const Icon(Icons.delete, color: AppColors.danger), onPressed: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}
