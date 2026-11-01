import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/edit_group_controller.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_date_field.dart';
import '../../widgets/participant_tile.dart';
import '../../widgets/status_badge.dart';

class EditGroupScreen extends GetView<EditGroupController> {
  const EditGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Group'),
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
            CustomTextField(
              label: 'Group Name',
              controller: TextEditingController(text: group.name),
              enabled: false,
              readOnly: true,
            ),
            CustomDateField(
              label: 'Date of Creation',
              date: controller.dateOfCreation.value,
              onDateSelected: controller.updateDate,
            ),
            Row(
              children: [
                _infoBox('Status', child: StatusBadge(status: group.status)),
                const SizedBox(width: 12),
                _infoBox(
                  'Total / Pending',
                  child: Text(
                    '\u20b9${group.totalAmount.toStringAsFixed(0)} / \u20b9${group.pendingAmount.toStringAsFixed(0)}',
                    style: AppTextStyles.subHeading,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoBox(
                  'Advance Collected',
                  child: Text('\u20b9${group.advanceAmount.toStringAsFixed(0)}', style: AppTextStyles.subHeading),
                ),
                const SizedBox(width: 12),
                _infoBox(
                  'Final Payment Collected',
                  child: Text('\u20b9${group.finalPaymentAmount.toStringAsFixed(0)}', style: AppTextStyles.subHeading),
                ),
              ],
            ),
            const SizedBox(height: 16),
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

  Widget _infoBox(String label, {required Widget child}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}
