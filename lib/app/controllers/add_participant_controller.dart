import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/participant_model.dart';
import '../data/repository/group_repository.dart';

/// Drives the Add/Edit Participant screen. It works in two modes:
///
/// - "DB mode" ([isDbMode] true): a real [groupId] was passed in, so the
///   participant is written straight to the database and the screen
///   returns `true` on success (used from Edit Group / Group Details).
/// - "In-memory mode": no [groupId] yet because the group itself hasn't
///   been created, so the screen simply returns the built
///   [ParticipantModel] to the caller (used from Create Group).
class AddParticipantController extends GetxController {
  final GroupRepository _repository = Get.find<GroupRepository>();

  final nameController = TextEditingController();
  final passportController = TextEditingController();
  final mobileController = TextEditingController();
  final totalController = TextEditingController();
  final advanceController = TextEditingController();
  final finalPaymentController = TextEditingController();
  final Rx<DateTime> joiningDate = DateTime.now().obs;
  final RxBool isSaving = false.obs;

  int? groupId;
  ParticipantModel? editingParticipant;
  List<String> existingPassports = [];

  bool get isDbMode => groupId != null;
  bool get isEditMode => editingParticipant != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    groupId = args['groupId'] as int?;
    editingParticipant = args['participant'] as ParticipantModel?;
    existingPassports = (args['existingPassports'] as List?)?.cast<String>() ?? [];

    final existing = editingParticipant;
    if (existing != null) {
      nameController.text = existing.name;
      passportController.text = existing.passportNumber;
      mobileController.text = existing.mobileNumber;
      totalController.text = existing.totalAmount.toStringAsFixed(0);
      advanceController.text = existing.advanceAmount.toStringAsFixed(0);
      finalPaymentController.text = existing.finalPaymentAmount.toStringAsFixed(0);
      joiningDate.value = existing.joiningDate;
    }
  }

  void setJoiningDate(DateTime date) => joiningDate.value = date;

  Future<void> save() async {
    final name = nameController.text.trim();
    final passport = passportController.text.trim();
    final mobile = mobileController.text.trim();
    final total = double.tryParse(totalController.text.trim());
    final advance = double.tryParse(advanceController.text.trim());
    final finalPayment = double.tryParse(
      finalPaymentController.text.trim().isEmpty ? '0' : finalPaymentController.text.trim(),
    );

    if (name.isEmpty ||
        passport.isEmpty ||
        mobile.isEmpty ||
        total == null ||
        advance == null ||
        finalPayment == null) {
      Get.snackbar('Missing details', 'Please fill all fields with valid values');
      return;
    }
    if (advance + finalPayment > total) {
      Get.snackbar('Invalid amount', 'Advance + Final Payment cannot exceed total amount');
      return;
    }

    isSaving.value = true;

    if (isDbMode) {
      await _saveToDatabase(
        name: name,
        passport: passport,
        mobile: mobile,
        total: total,
        advance: advance,
        finalPayment: finalPayment,
      );
    } else {
      _saveInMemory(
        name: name,
        passport: passport,
        mobile: mobile,
        total: total,
        advance: advance,
        finalPayment: finalPayment,
      );
    }
  }

  Future<void> _saveToDatabase({
    required String name,
    required String passport,
    required String mobile,
    required double total,
    required double advance,
    required double finalPayment,
  }) async {
    final isUnique = await _repository.isPassportUnique(
      groupId!,
      passport,
      excludeParticipantId: editingParticipant?.id,
    );
    if (!isUnique) {
      isSaving.value = false;
      Get.snackbar('Duplicate Passport', 'This passport number already exists in the group');
      return;
    }

    if (isEditMode) {
      await _repository.updateParticipant(editingParticipant!.copyWith(
        name: name,
        passportNumber: passport,
        mobileNumber: mobile,
        joiningDate: joiningDate.value,
        totalAmount: total,
        advanceAmount: advance,
        finalPaymentAmount: finalPayment,
      ));
    } else {
      await _repository.addParticipant(ParticipantModel(
        groupId: groupId!,
        name: name,
        passportNumber: passport,
        mobileNumber: mobile,
        joiningDate: joiningDate.value,
        totalAmount: total,
        advanceAmount: advance,
        finalPaymentAmount: finalPayment,
      ));
    }

    isSaving.value = false;
    Get.back(result: true);
  }

  void _saveInMemory({
    required String name,
    required String passport,
    required String mobile,
    required double total,
    required double advance,
    required double finalPayment,
  }) {
    if (existingPassports.contains(passport)) {
      isSaving.value = false;
      Get.snackbar('Duplicate Passport', 'This passport number already exists in the group');
      return;
    }

    final participant = ParticipantModel(
      groupId: editingParticipant?.groupId ?? -1,
      name: name,
      passportNumber: passport,
      mobileNumber: mobile,
      joiningDate: joiningDate.value,
      totalAmount: total,
      advanceAmount: advance,
      finalPaymentAmount: finalPayment,
    );

    isSaving.value = false;
    Get.back(result: participant);
  }

  @override
  void onClose() {
    nameController.dispose();
    passportController.dispose();
    mobileController.dispose();
    totalController.dispose();
    advanceController.dispose();
    finalPaymentController.dispose();
    super.onClose();
  }
}
