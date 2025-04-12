import 'dart:developer';

import 'package:nucatch_with_bloc/models/turn_record_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TurnRecordedServices {
  Database? _database;

  TurnRecordedServices();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'turn_records.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE turn_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            turnId TEXT NOT NULL,
            playedUsername TEXT NOT NULL,
            point INTEGER NOT NULL,
            recordedTime TEXT NOT NULL
          )
        ''');
      },
      version: 1,
    );
  }

  Future<List<TurnRecordedModel>?> getTurnedList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('turn_records');

    return maps.map((map) {
      return TurnRecordedModel(
        turnId: map['turnId'],
        playedUsername: map['playedUsername'],
        point: map['point'],
        recordedTime: DateTime.parse(map['recordedTime']),
      );
    }).toList();
  }

  Future<bool> addItem(TurnRecordedModel item) async {
    final db = await database;
    try {
      await db.insert(
        'turn_records',
        {
          'turnId': item.turnId,
          'playedUsername': item.playedUsername,
          'point': item.point,
          'recordedTime': item.recordedTime.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      log(item.toString());
      return true;
    } catch (e) {
      log('Error adding item: $e');
      return false;
    }
  }
}
