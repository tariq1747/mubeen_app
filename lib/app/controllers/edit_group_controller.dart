import 'package:get/get.dart';
import '../data/models/group_model.dart';
import '../data/models/participant_model.dart';
import '../data/repository/group_repository.dart';
import '../routes/app_routes.dart';
import '../ui/widgets/confirm_dialog.dart';

/// Drives the Edit Group screen. The group already exists in the database,
/// so the name stays read-only and every other change (date, participants)
/// is written straight through the repository. Total/pending/status are
/// always recomputed from participants - they are never edited directly.
class EditGroupController extends GetxController {
  final GroupRepository _repository = Get.find<GroupRepository>();
  late final int groupId;

  final Rx<GroupModel?> group = Rx<GroupModel?>(null);
  final Rx<DateTime> dateOfCreation = DateTime.now().obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    groupId = Get.arguments as int;
    loadGroup();
  }

  Future<void> loadGroup() async {
    isLoading.value = true;
    final result = await _repository.fetchGroupDetails(groupId);
    group.value = result;
    if (result != null) dateOfCreation.value = result.dateOfCreation;
    isLoading.value = false;
  }

  Future<void> updateDate(DateTime date) async {
    final current = group.value;
    if (current == null) return;
    await _repository.updateGroup(current.copyWith(dateOfCreation: date));
    await loadGroup();
  }

  Future<void> openAddParticipant() async {
    final result = await Get.toNamed(AppRoutes.addParticipant, arguments: {'groupId': groupId});
    if (result == true) await loadGroup();
  }

  Future<void> openEditParticipant(ParticipantModel participant) async {
    final result = await Get.toNamed(
      AppRoutes.addParticipant,
      arguments: {'groupId': groupId, 'participant': participant},
    );
    if (result == true) await loadGroup();
  }

  Future<void> deleteParticipant(ParticipantModel participant) async {
    final confirmed = await ConfirmDialog.show(
      title: 'Delete Participant',
      message: 'Remove "${participant.name}" from this group?',
    );
    if (!confirmed) return;

    await _repository.deleteParticipant(participant.id!);
    await loadGroup();
  }
}
