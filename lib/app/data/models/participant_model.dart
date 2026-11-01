class ParticipantModel {
  final int? id;
  final int groupId;
  final String name;
  final String passportNumber;
  final String mobileNumber;
  final DateTime joiningDate;
  final double totalAmount;
  final double advanceAmount;
  final double finalPaymentAmount;

  const ParticipantModel({
    this.id,
    required this.groupId,
    required this.name,
    required this.passportNumber,
    required this.mobileNumber,
    required this.joiningDate,
    required this.totalAmount,
    required this.advanceAmount,
    this.finalPaymentAmount = 0,
  });

  /// Total amount actually collected from this participant so far.
  double get collectedAmount => advanceAmount + finalPaymentAmount;

  /// Pending amount is always derived, never stored or entered manually.
  /// Pending = Total - Advance - Final Payment.
  double get pendingAmount => totalAmount - collectedAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_id': groupId,
      'name': name,
      'passport_number': passportNumber,
      'mobile_number': mobileNumber,
      'joining_date': joiningDate.toIso8601String(),
      'total_amount': totalAmount,
      'advance_amount': advanceAmount,
      'final_payment_amount': finalPaymentAmount,
    };
  }

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map['id'] as int?,
      groupId: map['group_id'] as int,
      name: map['name'] as String,
      passportNumber: map['passport_number'] as String,
      mobileNumber: map['mobile_number'] as String,
      joiningDate: DateTime.parse(map['joining_date'] as String),
      totalAmount: (map['total_amount'] as num).toDouble(),
      advanceAmount: (map['advance_amount'] as num).toDouble(),
      finalPaymentAmount: (map['final_payment_amount'] as num?)?.toDouble() ?? 0,
    );
  }

  ParticipantModel copyWith({
    int? id,
    int? groupId,
    String? name,
    String? passportNumber,
    String? mobileNumber,
    DateTime? joiningDate,
    double? totalAmount,
    double? advanceAmount,
    double? finalPaymentAmount,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      passportNumber: passportNumber ?? this.passportNumber,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      joiningDate: joiningDate ?? this.joiningDate,
      totalAmount: totalAmount ?? this.totalAmount,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      finalPaymentAmount: finalPaymentAmount ?? this.finalPaymentAmount,
    );
  }
}
