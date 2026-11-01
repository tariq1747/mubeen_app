import 'participant_model.dart';
import 'group_status.dart';

class GroupModel {
  final int? id;
  final String name;
  final DateTime dateOfCreation;
  final List<ParticipantModel> participants;

  const GroupModel({
    this.id,
    required this.name,
    required this.dateOfCreation,
    this.participants = const [],
  });

  /// Group total is always the sum of participant totals - never entered manually.
  double get totalAmount => participants.fold(0.0, (sum, p) => sum + p.totalAmount);

  /// Sum of advance amounts collected from all participants.
  double get advanceAmount => participants.fold(0.0, (sum, p) => sum + p.advanceAmount);

  /// Sum of final payment amounts collected from all participants.
  double get finalPaymentAmount => participants.fold(0.0, (sum, p) => sum + p.finalPaymentAmount);

  /// Total collected so far = advance + final payments, across all participants.
  double get collectedAmount => advanceAmount + finalPaymentAmount;

  /// Pending = total - advance - final payment, recalculated live from participants.
  double get pendingAmount => totalAmount - collectedAmount;

  /// Status is fully derived - it can never be set directly by the user.
  GroupStatus get status => computeGroupStatus(total: totalAmount, collected: collectedAmount);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date_of_creation': dateOfCreation.toIso8601String(),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map, {List<ParticipantModel> participants = const []}) {
    return GroupModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      dateOfCreation: DateTime.parse(map['date_of_creation'] as String),
      participants: participants,
    );
  }

  GroupModel copyWith({
    int? id,
    String? name,
    DateTime? dateOfCreation,
    List<ParticipantModel>? participants,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfCreation: dateOfCreation ?? this.dateOfCreation,
      participants: participants ?? this.participants,
    );
  }
}
