import 'package:get/get.dart';
import '../data/models/group_model.dart';
import '../data/models/participant_model.dart';
import '../data/repository/group_repository.dart';
import '../routes/app_routes.dart';
import '../ui/widgets/confirm_dialog.dart';

/// Drives the read-focused Group Details screen. Also lets the user manage
/// participants (add/edit/delete) directly from here, as requested.
class GroupDetailsController extends GetxController {
  final GroupRepository _repository = Get.find<GroupRepository>();
  late final int groupId;

  final Rx<GroupModel?> group = Rx<GroupModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    groupId = Get.arguments as int;
    loadGroup();
  }

  Future<void> loadGroup() async {
    isLoading.value = true;
    group.value = await _repository.fetchGroupDetails(groupId);
    isLoading.value = false;
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
