import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/add_participant_controller.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_date_field.dart';

class AddParticipantScreen extends GetView<AddParticipantController> {
  const AddParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditMode ? 'Edit Participant' : 'Add Participant'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CustomTextField(label: 'Name', controller: controller.nameController, hint: 'Enter participant name'),
            CustomTextField(
              label: 'Passport Number',
              controller: controller.passportController,
              hint: 'Enter passport number',
            ),
            CustomTextField(
              label: 'Mobile Number',
              controller: controller.mobileController,
              hint: 'Enter mobile number',
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            Obx(
              () => CustomDateField(
                label: 'Date',
                date: controller.joiningDate.value,
                onDateSelected: controller.setJoiningDate,
              ),
            ),
            CustomTextField(
              label: 'Total Amount',
              controller: controller.totalController,
              hint: '0',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            ),
            CustomTextField(
              label: 'Advance Amount',
              controller: controller.advanceController,
              hint: '0',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            ),
            CustomTextField(
              label: 'Final Payment',
              controller: controller.finalPaymentController,
              hint: '0',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            ),
            const SizedBox(height: 10),
            Obx(
              () => CustomButton(
                label: controller.isEditMode ? 'Update Participant' : 'Add Participant',
                isLoading: controller.isSaving.value,
                onPressed: controller.save,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
