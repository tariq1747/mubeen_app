import 'package:flutter/material.dart';
import '../../data/models/group_model.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'status_badge.dart';
import 'custom_button.dart';
import '../../utils/date_utils.dart';

/// Card shown on the Home screen for a single group: status, dates,
/// payment summary, a preview of participants and the group's actions.
class GroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GroupCard({
    super.key,
    required this.group,
    required this.onDetails,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(group.name, style: AppTextStyles.heading)),
              StatusBadge(status: group.status),
            ],
          ),
          const SizedBox(height: 4),
          Text('Created: ${AppDateUtils.format(group.dateOfCreation)}', style: AppTextStyles.caption),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _amountBlock('Total', group.totalAmount),
              _amountBlock('Advance', group.advanceAmount),
              _amountBlock('Final', group.finalPaymentAmount),
              _amountBlock('Pending', group.pendingAmount),
            ],
          ),
          if (group.participants.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Text('Participants (${group.participants.length})', style: AppTextStyles.subHeading),
            const SizedBox(height: 6),
            ...group.participants.take(3).map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('${p.name} \u2022 Passport: ${p.passportNumber}', style: AppTextStyles.caption),
                  ),
                ),
            if (group.participants.length > 3)
              Text('+ ${group.participants.length - 3} more', style: AppTextStyles.caption),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: CustomButton(label: 'Details', type: ButtonType.outline, onPressed: onDetails)),
              const SizedBox(width: 8),
              Expanded(child: CustomButton(label: 'Edit', onPressed: onEdit)),
              const SizedBox(width: 8),
              Expanded(child: CustomButton(label: 'Delete', type: ButtonType.danger, onPressed: onDelete)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountBlock(String label, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text('\u20b9${amount.toStringAsFixed(0)}', style: AppTextStyles.subHeading),
      ],
    );
  }
}
