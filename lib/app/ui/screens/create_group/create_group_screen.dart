import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/create_group_controller.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_date_field.dart';
import '../../widgets/participant_tile.dart';

class CreateGroupScreen extends GetView<CreateGroupController> {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  CustomTextField(label: 'Group Name', controller: controller.nameController, hint: 'Enter group name'),
                  Obx(
                    () => CustomDateField(
                      label: 'Date of Creation',
                      date: controller.dateOfCreation.value,
                      onDateSelected: controller.pickDate,
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        _amountBox('Total Amount', controller.totalAmount),
                        const SizedBox(width: 12),
                        _amountBox('Pending Amount', controller.pendingAmount),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Participants', style: AppTextStyles.subHeading),
                      CustomButton(label: '+ Add', type: ButtonType.outline, onPressed: controller.openAddParticipant),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Column(
                      children: controller.participants
                          .asMap()
                          .entries
                          .map(
                            (entry) => ParticipantTile(
                              participant: entry.value,
                              onEdit: () => controller.openEditParticipant(entry.value, entry.key),
                              onDelete: () => controller.removeParticipant(entry.key),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => CustomButton(
                label: 'Save Group',
                isLoading: controller.isSaving.value,
                onPressed: controller.saveGroup,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountBox(String label, double amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text('\u20b9${amount.toStringAsFixed(0)}', style: AppTextStyles.subHeading),
          ],
        ),
      ),
    );
  }
}
