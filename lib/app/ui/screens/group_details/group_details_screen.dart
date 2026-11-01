import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/group_details_controller.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/participant_tile.dart';
import '../../widgets/status_badge.dart';
import '../../../utils/date_utils.dart';

class GroupDetailsScreen extends GetView<GroupDetailsController> {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        final group = controller.group.value;
        if (group == null) return const Center(child: Text('Group not found'));

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(group.name, style: AppTextStyles.heading)),
                StatusBadge(status: group.status),
              ],
            ),
            const SizedBox(height: 4),
            Text('Created: ${AppDateUtils.format(group.dateOfCreation)}', style: AppTextStyles.caption),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _summaryBox('Total Amount', group.totalAmount),
                _summaryBox('Advance', group.advanceAmount),
                _summaryBox('Final Payment', group.finalPaymentAmount),
                _summaryBox('Pending', group.pendingAmount),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Participants (${group.participants.length})', style: AppTextStyles.subHeading),
                CustomButton(label: '+ Add', type: ButtonType.outline, onPressed: controller.openAddParticipant),
              ],
            ),
            const SizedBox(height: 10),
            ...group.participants.map(
              (p) => ParticipantTile(
                participant: p,
                onEdit: () => controller.openEditParticipant(p),
                onDelete: () => controller.deleteParticipant(p),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryBox(String label, double amount) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text('\u20b9${amount.toStringAsFixed(0)}', style: AppTextStyles.subHeading),
        ],
      ),
    );
  }
}
