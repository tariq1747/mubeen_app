/// Represents the lifecycle state of a group.
///
/// - [start]: default state when a group is created and no advance has
///   been collected from any participant yet.
/// - [process]: at least some advance has been collected but the group
///   still has a pending balance.
/// - [completed]: the full amount has been collected from all participants.
enum GroupStatus { start, process, completed }

extension GroupStatusX on GroupStatus {
  String get label {
    switch (this) {
      case GroupStatus.start:
        return 'Start';
      case GroupStatus.process:
        return 'In Process';
      case GroupStatus.completed:
        return 'Completed';
    }
  }
}

/// Business rule for deriving a group's status from its computed totals.
/// This keeps status logic in one place so it is never set manually.
/// [collected] is the total collected from participants so far
/// (advance payments + final payments combined).
GroupStatus computeGroupStatus({required double total, required double collected}) {
  if (total <= 0) return GroupStatus.start;
  if (collected <= 0) return GroupStatus.start;
  if (collected >= total) return GroupStatus.completed;
  return GroupStatus.process;
}
