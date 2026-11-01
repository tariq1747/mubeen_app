import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/group_model.dart';
import '../data/models/participant_model.dart';
import '../data/repository/group_repository.dart';
import '../routes/app_routes.dart';

/// Drives the Create Group screen. Participants are kept in memory until
/// "Save Group" is pressed, because the group (and its id) does not exist
/// in the database yet.
class CreateGroupController extends GetxController {
  final GroupRepository _repository = Get.find<GroupRepository>();

  final nameController = TextEditingController();
  final Rx<DateTime> dateOfCreation = DateTime.now().obs;
  final RxList<ParticipantModel> participants = <ParticipantModel>[].obs;
  final RxBool isSaving = false.obs;

  double get totalAmount => participants.fold(0.0, (sum, p) => sum + p.totalAmount);
  double get advanceAmount => participants.fold(0.0, (sum, p) => sum + p.advanceAmount);
  double get pendingAmount => totalAmount - advanceAmount;

  void pickDate(DateTime date) => dateOfCreation.value = date;

  Future<void> openAddParticipant() async {
    final result = await Get.toNamed(
      AppRoutes.addParticipant,
      arguments: {'existingPassports': participants.map((p) => p.passportNumber).toList()},
    );
    if (result is ParticipantModel) participants.add(result);
  }

  Future<void> openEditParticipant(ParticipantModel participant, int index) async {
    final otherPassports = participants
        .where((p) => p.passportNumber != participant.passportNumber)
        .map((p) => p.passportNumber)
        .toList();

    final result = await Get.toNamed(
      AppRoutes.addParticipant,
      arguments: {'participant': participant, 'existingPassports': otherPassports},
    );
    if (result is ParticipantModel) participants[index] = result;
  }

  void removeParticipant(int index) => participants.removeAt(index);

  Future<void> saveGroup() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Missing Name', 'Please enter a group name');
      return;
    }

    isSaving.value = true;
    final group = GroupModel(name: name, dateOfCreation: dateOfCreation.value);
    await _repository.createGroup(group, participants.toList());
    isSaving.value = false;

    Get.back(result: true);
    Get.snackbar('Success', 'Group created successfully');
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
