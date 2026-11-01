import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/group_model.dart';

/// Pure data-access layer for the groups table. Contains no business logic.
class GroupDao {
  Future<Database> get _db async => DBHelper.instance.database;

  Future<int> insertGroup(GroupModel group) async {
    final db = await _db;
    final map = group.toMap()..remove('id');
    return db.insert(DBHelper.groupsTable, map);
  }

  Future<int> updateGroup(GroupModel group) async {
    final db = await _db;
    final map = group.toMap()..remove('id');
    return db.update(DBHelper.groupsTable, map, where: 'id = ?', whereArgs: [group.id]);
  }

  /// Relies on ON DELETE CASCADE (foreign_keys PRAGMA is enabled) to also
  /// remove every participant that belongs to this group.
  Future<int> deleteGroup(int groupId) async {
    final db = await _db;
    return db.delete(DBHelper.groupsTable, where: 'id = ?', whereArgs: [groupId]);
  }

  Future<List<Map<String, dynamic>>> fetchAllGroups() async {
    final db = await _db;
    return db.query(DBHelper.groupsTable, orderBy: 'date_of_creation DESC');
  }

  Future<Map<String, dynamic>?> fetchGroupById(int id) async {
    final db = await _db;
    final result = await db.query(DBHelper.groupsTable, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }
}
