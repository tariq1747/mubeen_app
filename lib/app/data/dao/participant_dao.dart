import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/participant_model.dart';

/// Pure data-access layer for the participants table. Contains no business logic.
class ParticipantDao {
  Future<Database> get _db async => DBHelper.instance.database;

  Future<int> insertParticipant(ParticipantModel participant) async {
    final db = await _db;
    final map = participant.toMap()..remove('id');
    return db.insert(DBHelper.participantsTable, map);
  }

  Future<int> updateParticipant(ParticipantModel participant) async {
    final db = await _db;
    final map = participant.toMap()..remove('id');
    return db.update(DBHelper.participantsTable, map, where: 'id = ?', whereArgs: [participant.id]);
  }

  Future<int> deleteParticipant(int id) async {
    final db = await _db;
    return db.delete(DBHelper.participantsTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> fetchParticipantsByGroup(int groupId) async {
    final db = await _db;
    return db.query(DBHelper.participantsTable, where: 'group_id = ?', whereArgs: [groupId]);
  }

  /// Enforces "passport number unique within a group" at the application
  /// level as well as via the DB's UNIQUE(group_id, passport_number) constraint.
  Future<bool> isPassportUniqueInGroup(
    int groupId,
    String passportNumber, {
    int? excludeParticipantId,
  }) async {
    final db = await _db;
    final where = excludeParticipantId == null
        ? 'group_id = ? AND passport_number = ?'
        : 'group_id = ? AND passport_number = ? AND id != ?';
    final args = excludeParticipantId == null
        ? [groupId, passportNumber]
        : [groupId, passportNumber, excludeParticipantId];
    final result = await db.query(DBHelper.participantsTable, where: where, whereArgs: args);
    return result.isEmpty;
  }
}
