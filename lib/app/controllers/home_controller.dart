import 'package:get/get.dart';
import '../data/models/group_model.dart';
import '../data/models/group_status.dart';
import '../data/repository/group_repository.dart';
import '../routes/app_routes.dart';
import '../ui/widgets/confirm_dialog.dart';

/// Drives the Home screen: loading groups, search, date + status filters
/// and the navigation / delete actions triggered from a [GroupCard].
class HomeController extends GetxController {
  final GroupRepository _repository = Get.find<GroupRepository>();

  final RxList<GroupModel> allGroups = <GroupModel>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<GroupStatus?> selectedStatus = Rx<GroupStatus?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  Future<void> loadGroups() async {
    isLoading.value = true;
    final groups = await _repository.fetchAllGroupsWithParticipants();
    allGroups.assignAll(groups);
    isLoading.value = false;
  }

  /// Search matches group name, participant name or participant passport
  /// number; combined with the optional date and status filters.
  List<GroupModel> get filteredGroups {
    final query = searchQuery.value.trim().toLowerCase();
    final date = selectedDate.value;
    final status = selectedStatus.value;

    return allGroups.where((group) {
      final matchesQuery = query.isEmpty ||
          group.name.toLowerCase().contains(query) ||
          group.participants.any((p) =>
              p.name.toLowerCase().contains(query) || p.passportNumber.toLowerCase().contains(query));

      final matchesDate = date == null ||
          (group.dateOfCreation.year == date.year &&
              group.dateOfCreation.month == date.month &&
              group.dateOfCreation.day == date.day);

      final matchesStatus = status == null || group.status == status;

      return matchesQuery && matchesDate && matchesStatus;
    }).toList();
  }

  bool get hasActiveFilters =>
      searchQuery.value.isNotEmpty || selectedDate.value != null || selectedStatus.value != null;

  void onSearchChanged(String value) => searchQuery.value = value;

  void onDateSelected(DateTime? date) => selectedDate.value = date;

  void onStatusSelected(GroupStatus? status) => selectedStatus.value = status;

  void clearFilters() {
    searchQuery.value = '';
    selectedDate.value = null;
    selectedStatus.value = null;
  }

  void goToCreateGroup() => Get.toNamed(AppRoutes.createGroup)?.then((_) => loadGroups());

  void goToDetails(int groupId) => Get.toNamed(AppRoutes.groupDetails, arguments: groupId)?.then((_) => loadGroups());

  void goToEdit(int groupId) => Get.toNamed(AppRoutes.editGroup, arguments: groupId)?.then((_) => loadGroups());

  Future<void> deleteGroup(GroupModel group) async {
    final confirmed = await ConfirmDialog.show(
      title: 'Delete Group',
      message:
          'This will permanently delete "${group.name}" and all ${group.participants.length} participant(s) in it. This action cannot be undone.',
    );
    if (!confirmed) return;

    await _repository.deleteGroup(group.id!);
    await loadGroups();
    Get.snackbar('Deleted', 'Group "${group.name}" has been deleted');
  }
}
