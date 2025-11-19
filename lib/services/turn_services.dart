import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TurnRecordedServices {
  Database? _database;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TurnRecordedServices();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Table and column names as constants
  static const String tableTurnRecords = 'turn_records';
  // Table columns and types as constants
  static const List<String> columns = [
    'id',
    PreferencesKey.TURN_ID,
    PreferencesKey.PLAYED_USERNAME,
    PreferencesKey.POINT,
    PreferencesKey.RECORDED_TIME,
    PreferencesKey.DIFFICULTY,
  ];

  static const Map<String, String> columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    PreferencesKey.TURN_ID: 'TEXT NOT NULL',
    PreferencesKey.PLAYED_USERNAME: 'TEXT',
    PreferencesKey.POINT: 'INTEGER NOT NULL',
    PreferencesKey.RECORDED_TIME: 'TEXT NOT NULL',
    PreferencesKey.DIFFICULTY: "TEXT NOT NULL DEFAULT 'easy'",
  };

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, '$tableTurnRecords.db'),
      version: 2,
      onCreate: (db, version) async {
        final columnsDef =
            columns.map((col) => '$col ${columnTypes[col]}').join(', ');
        await db.execute('CREATE TABLE $tableTurnRecords ($columnsDef)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _alterTableIfNeeded(db);
      },
    );
  }

  Future<void> _alterTableIfNeeded(Database db) async {
    final res = await db.rawQuery("PRAGMA table_info($tableTurnRecords)");
    final existingColumns = res.map((row) => row['name'] as String).toSet();

    for (final col in columns) {
      if (!existingColumns.contains(col)) {
        await db.execute(
            'ALTER TABLE $tableTurnRecords ADD COLUMN $col ${columnTypes[col]}');
      }
    }
  }

  Future<List<TurnRecordedModel>?> getTurnedList(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'turn_records',
      orderBy: '${PreferencesKey.POINT} DESC',
      limit: limit,
    );

    return maps.map((map) {
      return TurnRecordedModel.fromJson(map);
    }).toList();
  }

  // Get daily rankings (today only)
  Future<List<TurnRecordedModel>?> getDailyTurnedList(int limit) async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Use milliseconds for comparison since that's how it's stored in local DB
    final List<Map<String, dynamic>> maps = await db.query(
      tableTurnRecords,
      where:
          '${PreferencesKey.RECORDED_TIME} >= ? AND ${PreferencesKey.RECORDED_TIME} < ?',
      whereArgs: [
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch
      ],
      orderBy: '${PreferencesKey.POINT} DESC',
      limit: limit,
    );

    return maps.map((map) => TurnRecordedModel.fromJson(map)).toList();
  }

  // Get weekly rankings (last 7 days)
  Future<List<TurnRecordedModel>?> getWeeklyTurnedList(int limit) async {
    final db = await database;
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    // Use milliseconds for comparison since that's how it's stored in local DB
    final List<Map<String, dynamic>> maps = await db.query(
      tableTurnRecords,
      where: '${PreferencesKey.RECORDED_TIME} >= ?',
      whereArgs: [weekAgo.millisecondsSinceEpoch],
      orderBy: '${PreferencesKey.POINT} DESC',
      limit: limit,
    );

    return maps.map((map) => TurnRecordedModel.fromJson(map)).toList();
  }

  // Get all time rankings (existing method renamed for clarity)
  Future<List<TurnRecordedModel>?> getAllTimeTurnedList(int limit) async {
    return await getTurnedList(limit);
  }

  Future<List<TurnRecordedModel>?> getTurnedListFirebase(int limit) async {
    final querySnapshot = await firebaseFirestore
        .collection('turn_records')
        .orderBy(PreferencesKey.POINT, descending: true)
        .orderBy(PreferencesKey.RECORDED_TIME)
        .limit(limit)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final TurnRecordedModel item = TurnRecordedModel.fromJson(data);
      return item;
    }).toList();
  }

  // Get daily rankings from Firebase (today only)
  Future<List<TurnRecordedModel>?> getDailyTurnedListFirebase(int limit) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Ensure we use integer milliseconds for comparison
    final startOfDayMillis = startOfDay.millisecondsSinceEpoch;
    final endOfDayMillis = endOfDay.millisecondsSinceEpoch;

    // Firebase stores recordedTime as milliseconds, so use integer milliseconds for comparison
    final querySnapshot = await firebaseFirestore
        .collection('turn_records')
        .where(PreferencesKey.RECORDED_TIME,
            isGreaterThanOrEqualTo: startOfDayMillis)
        .where(PreferencesKey.RECORDED_TIME, isLessThan: endOfDayMillis)
        .orderBy(PreferencesKey.POINT, descending: true)
        .orderBy(PreferencesKey.RECORDED_TIME)
        .limit(limit)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return TurnRecordedModel.fromJson(data);
    }).toList();
  }

  // Get weekly rankings from Firebase (last 7 days)
  Future<List<TurnRecordedModel>?> getWeeklyTurnedListFirebase(
      int limit) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    // Ensure we use integer milliseconds for comparison
    final weekAgoMillis = weekAgo.millisecondsSinceEpoch;

    // Firebase stores recordedTime as milliseconds, so use integer milliseconds for comparison
    final querySnapshot = await firebaseFirestore
        .collection('turn_records')
        .where(PreferencesKey.RECORDED_TIME,
            isGreaterThanOrEqualTo: weekAgoMillis)
        .orderBy(PreferencesKey.POINT, descending: true)
        .orderBy(PreferencesKey.RECORDED_TIME)
        // .orderBy(PreferencesKey.PLAYED_USERNAME, descending: true)
        .limit(limit)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return TurnRecordedModel.fromJson(data);
    }).toList();
  }

  // Get all time rankings from Firebase (existing method renamed for clarity)
  Future<List<TurnRecordedModel>?> getAllTimeTurnedListFirebase(
      int limit) async {
    return await getTurnedListFirebase(limit);
  }

  // Convenient method to get data by period type
  Future<List<TurnRecordedModel>?> getTurnedListByPeriod(
      String period, int limit,
      {bool useFirebase = false}) async {
    switch (period.toLowerCase()) {
      case 'daily':
        return await getDailyTurnedListFirebase(limit) ??
            await getDailyTurnedList(limit);
      case 'weekly':
        return await getWeeklyTurnedListFirebase(limit) ??
            await getWeeklyTurnedList(limit);
      case 'all':
      case 'alltime':
      default:
        return await getAllTimeTurnedListFirebase(limit) ??
            await getAllTimeTurnedList(limit);
    }
  }

  // Debug method to help troubleshoot date filtering issues
  Future<void> debugDatabaseContent() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableTurnRecords);

    log('=== DATABASE CONTENT DEBUG ===');
    log('Total records: ${maps.length}');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    log('Current time: $now');
    log('Today start: $today');
    log('Today start (millis): ${today.millisecondsSinceEpoch}');

    for (final map in maps) {
      final recordedTime = map['recordedTime'];
      DateTime? parsedTime;

      if (recordedTime is String && recordedTime.contains('T')) {
        parsedTime = DateTime.tryParse(recordedTime);
      } else if (recordedTime is int || recordedTime is String) {
        final millis = recordedTime is int
            ? recordedTime
            : int.tryParse(recordedTime.toString());
        if (millis != null) {
          parsedTime = DateTime.fromMillisecondsSinceEpoch(millis);
        }
      }

      log('Record - Point: ${map['point']}, RecordedTime raw: $recordedTime, Parsed: $parsedTime');

      if (parsedTime != null) {
        final isToday = parsedTime.year == now.year &&
            parsedTime.month == now.month &&
            parsedTime.day == now.day;
        log('  -> Is today: $isToday');
      }
    }
    log('=== END DEBUG ===');
  }

  Future<bool> addItem(TurnRecordedModel item) async {
    final db = await database;
    try {
      await db.insert(
        tableTurnRecords,
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log("inserted to local database");
      return true;
    } catch (e) {
      log('Error adding item: $e');
      return false;
    }
  }

  Future<bool> addItemToFirebase(TurnRecordedModel item) async {
    try {
      await firebaseFirestore.collection('turn_records').add(
            item.toJson(),
          );

      log("inserted to Firebase database");

      return true;
    } catch (e) {
      log('Error adding item: $e');
      return false;
    }
  }
}
