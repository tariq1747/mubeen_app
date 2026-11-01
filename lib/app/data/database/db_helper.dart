import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Owns the single sqflite [Database] instance and schema creation.
/// All raw SQL / table definitions live only here and in the DAO classes,
/// keeping database concerns isolated from the rest of the app.
class DBHelper {
  DBHelper._internal();
  static final DBHelper instance = DBHelper._internal();

  static Database? _database;

  static const String groupsTable = 'trip_groups';
  static const String participantsTable = 'participants';

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'group_manager.db');

    return openDatabase(
      path,
      version: 2,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _createTables,
      onUpgrade: _upgradeTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $groupsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date_of_creation TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $participantsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        group_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        passport_number TEXT NOT NULL,
        mobile_number TEXT NOT NULL,
        joining_date TEXT NOT NULL,
        total_amount REAL NOT NULL DEFAULT 0,
        advance_amount REAL NOT NULL DEFAULT 0,
        final_payment_amount REAL NOT NULL DEFAULT 0,
        FOREIGN KEY (group_id) REFERENCES $groupsTable (id) ON DELETE CASCADE,
        UNIQUE (group_id, passport_number)
      )
    ''');
  }

  /// Adds the final_payment_amount column for anyone upgrading from v1,
  /// without losing any existing groups/participants data.
  Future<void> _upgradeTables(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $participantsTable ADD COLUMN final_payment_amount REAL NOT NULL DEFAULT 0',
      );
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
