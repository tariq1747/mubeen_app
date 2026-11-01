import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/group_status.dart';
import '../../../controllers/home_controller.dart';
import '../../widgets/app_colors.dart';
import '../../widgets/app_text_styles.dart';
import '../../widgets/group_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/app_logo.png',
                height: 36,
                width: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Al Fatima'),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToCreateGroup,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Group', style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadGroups,
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilters(context),
            const SizedBox(height: 8),
            Expanded(child: _buildGroupList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by group, participant name or passport',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Obx(
            () => controller.hasActiveFilters
                ? IconButton(
                    tooltip: 'Clear filters',
                    icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                    onPressed: controller.clearFilters,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _dateFilterButton(context)),
          const SizedBox(width: 10),
          Expanded(child: _statusFilterButton()),
        ],
      ),
    );
  }

  Widget _dateFilterButton(BuildContext context) {
    return Obx(() {
      final date = controller.selectedDate.value;
      final label = date == null ? 'Filter by date' : '${date.day}/${date.month}/${date.year}';
      return OutlinedButton.icon(
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime(2100),
          );
          if (picked != null) controller.onDateSelected(picked);
        },
        icon: const Icon(Icons.calendar_today, size: 16),
        label: Text(label, overflow: TextOverflow.ellipsis),
      );
    });
  }

  Widget _statusFilterButton() {
    return Obx(() {
      final status = controller.selectedStatus.value;
      return DropdownButtonFormField<GroupStatus?>(
        value: status,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        hint: const Text('All statuses'),
        items: [
          const DropdownMenuItem<GroupStatus?>(value: null, child: Text('All statuses')),
          ...GroupStatus.values.map((s) => DropdownMenuItem<GroupStatus?>(value: s, child: Text(s.label))),
        ],
        onChanged: controller.onStatusSelected,
      );
    });
  }

  Widget _buildGroupList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final groups = controller.filteredGroups;
      if (groups.isEmpty) {
        return Center(
          child: Text('No groups found', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return GroupCard(
            group: group,
            onDetails: () => controller.goToDetails(group.id!),
            onEdit: () => controller.goToEdit(group.id!),
            onDelete: () => controller.deleteGroup(group),
          );
        },
      );
    });
  }
}
