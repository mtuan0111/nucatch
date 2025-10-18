import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
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
    'turnId',
    'playedUsername',
    'point',
    'recordedTime',
    'difficulty',
  ];

  static const Map<String, String> columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'turnId': 'TEXT NOT NULL',
    'playedUsername': 'TEXT',
    'point': 'INTEGER NOT NULL',
    'recordedTime': 'TEXT NOT NULL',
    'difficulty': "TEXT NOT NULL DEFAULT 'easy'",
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
      orderBy: 'point DESC',
      limit: limit,
    );

    return maps.map((map) {
      return TurnRecordedModel(
        turnId: map['turnId'],
        playedUsername: map['playedUsername'],
        point: map['point'],
        recordedTime: DateTime.parse(map['recordedTime']),
        difficulty: Difficulty.values.firstWhere(
          (e) => e.name == map['difficulty'],
          orElse: () => Difficulty.easy,
        ),
      );
    }).toList();
  }

  Future<List<TurnRecordedModel>?> getTurnedListFirebase(int limit) async {
    final querySnapshot = await firebaseFirestore
        .collection('turn_records')
        .orderBy('point', descending: true)
        .limit(limit)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return TurnRecordedModel(
        turnId: data['turnId'],
        playedUsername: data['playedUsername'],
        point: data['point'],
        recordedTime: DateTime.parse(data['recordedTime']),
        difficulty: Difficulty.values.firstWhere(
          (e) => e.name == data['difficulty'],
          orElse: () => Difficulty.easy,
        ),
      );
    }).toList();
  }

  Future<bool> addItem(TurnRecordedModel item) async {
    final db = await database;
    try {
      await db.insert(
        tableTurnRecords,
        {
          'turnId': item.turnId,
          'playedUsername': item.playedUsername,
          'point': item.point,
          'recordedTime': item.recordedTime.toIso8601String(),
          'difficulty': item.difficulty.name,
        },
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
      Map<String, dynamic> newRecorded = {
        'turnId': item.turnId,
        'playedUsername': item.playedUsername,
        'point': item.point,
        'recordedTime': item.recordedTime.toIso8601String(),
        'difficulty': item.difficulty.name,
      };

      await firebaseFirestore.collection('turn_records').add(newRecorded);

      log("inserted to Firebase database");

      return true;
    } catch (e) {
      log('Error adding item: $e');
      return false;
    }
  }
}
