import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TurnRecordedServices {
  Database? _database;
  late final FirebaseFirestore? firebaseFirestore;

  // Cache for Firebase data with timestamps
  static final Map<String, List<TurnRecordedModel>?> _firebaseCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiration = Duration(hours: 1);

  TurnRecordedServices() {
    try {
      firebaseFirestore = FirebaseFirestore.instance;
    } catch (e) {
      print('⚠️ Firestore not available for turn services (offline mode): $e');
      firebaseFirestore = null;
    }
  }

  // Check if cache is valid for a given key
  bool _isCacheValid(String key) {
    if (!_firebaseCache.containsKey(key) ||
        !_cacheTimestamps.containsKey(key)) {
      return false;
    }
    final cacheTime = _cacheTimestamps[key]!;
    return DateTime.now().difference(cacheTime) < _cacheExpiration;
  }

  // Get data from cache
  List<TurnRecordedModel>? _getFromCache(String key) {
    if (_isCacheValid(key)) {
      return _firebaseCache[key];
    }
    return null;
  }

  // Set data to cache
  void _setToCache(String key, List<TurnRecordedModel>? data) {
    _firebaseCache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
  }

  // Clear all Firebase cache
  void _clearFirebaseCache() {
    _firebaseCache.clear();
    _cacheTimestamps.clear();
    log('Firebase cache cleared');
  }

  // Public method to clear cache (for refresh operations)
  void clearCache() {
    _clearFirebaseCache();
  }

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
    PreferencesKey.FIREBASE_USER_ID,
  ];

  static const Map<String, String> columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    PreferencesKey.TURN_ID: 'TEXT NOT NULL',
    PreferencesKey.PLAYED_USERNAME: 'TEXT',
    PreferencesKey.POINT: 'INTEGER NOT NULL',
    PreferencesKey.RECORDED_TIME: 'TEXT NOT NULL',
    PreferencesKey.DIFFICULTY: "TEXT NOT NULL DEFAULT 'easy'",
    PreferencesKey.FIREBASE_USER_ID: 'TEXT',
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
    final cacheKey = 'all_time_$limit';

    // Check cache first
    final cachedData = _getFromCache(cacheKey);
    if (cachedData != null) {
      log('Returning cached all-time data');
      return cachedData;
    }

    // Return empty list if in offline mode
    if (firebaseFirestore == null) {
      print('📱 Turn records unavailable (offline mode)');
      return [];
    }

    try {
      // Fetch from Firebase if not cached (with timeout for offline scenarios)
      final querySnapshot = await firebaseFirestore!
          .collection('turn_records')
          .orderBy(PreferencesKey.POINT, descending: true)
          .orderBy(PreferencesKey.RECORDED_TIME)
          .limit(limit)
          .get()
          .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          log('⏱️ Firestore query timed out, will use local data');
          throw TimeoutException('Firestore timeout');
        },
      );

      final result = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final TurnRecordedModel item = TurnRecordedModel.fromJson(data);
        return item;
      }).toList();

      // Cache the result
      _setToCache(cacheKey, result);
      log('Cached all-time data');

      return result;
    } catch (e) {
      log('Error fetching from Firebase (will use local data): $e');
      return []; // Return empty to trigger fallback to local DB
    }
  }

  // Get daily rankings from Firebase (today only)
  Future<List<TurnRecordedModel>?> getDailyTurnedListFirebase(int limit) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final cacheKey = 'daily_${startOfDay.millisecondsSinceEpoch}_$limit';

    // Check cache first
    final cachedData = _getFromCache(cacheKey);
    if (cachedData != null) {
      log('Returning cached daily data');
      return cachedData;
    }

    // Ensure we use integer milliseconds for comparison
    final startOfDayMillis = startOfDay.millisecondsSinceEpoch;
    final endOfDayMillis = endOfDay.millisecondsSinceEpoch;

    // Return empty list if in offline mode
    if (firebaseFirestore == null) {
      print('📱 Daily turn records unavailable (offline mode)');
      return [];
    }

    try {
      // Firebase stores recordedTime as milliseconds, so use integer milliseconds for comparison
      final querySnapshot = await firebaseFirestore!
          .collection('turn_records')
          .where(PreferencesKey.RECORDED_TIME,
              isGreaterThanOrEqualTo: startOfDayMillis)
          .where(PreferencesKey.RECORDED_TIME, isLessThan: endOfDayMillis)
          .orderBy(PreferencesKey.POINT, descending: true)
          .orderBy(PreferencesKey.RECORDED_TIME)
          .limit(limit)
          .get()
          .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          log('⏱️ Daily Firestore query timed out');
          throw TimeoutException('Firestore timeout');
        },
      );

      final result = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return TurnRecordedModel.fromJson(data);
      }).toList();

      // Cache the result
      _setToCache(cacheKey, result);
      log('Cached daily data');

      return result;
    } catch (e) {
      log('Error fetching daily data from Firebase: $e');
      return [];
    }
  }

  // Get weekly rankings from Firebase (last 7 days)
  Future<List<TurnRecordedModel>?> getWeeklyTurnedListFirebase(
      int limit) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final cacheKey = 'weekly_${weekAgo.millisecondsSinceEpoch}_$limit';

    // Check cache first
    final cachedData = _getFromCache(cacheKey);
    if (cachedData != null) {
      log('Returning cached weekly data');
      return cachedData;
    }

    // Ensure we use integer milliseconds for comparison
    final weekAgoMillis = weekAgo.millisecondsSinceEpoch;

    // Return empty list if in offline mode
    if (firebaseFirestore == null) {
      print('📱 Weekly turn records unavailable (offline mode)');
      return [];
    }

    try {
      // Firebase stores recordedTime as milliseconds, so use integer milliseconds for comparison
      final querySnapshot = await firebaseFirestore!
          .collection('turn_records')
          .where(PreferencesKey.RECORDED_TIME,
              isGreaterThanOrEqualTo: weekAgoMillis)
          .orderBy(PreferencesKey.POINT, descending: true)
          .orderBy(PreferencesKey.RECORDED_TIME)
          .limit(limit)
          .get()
          .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          log('⏱️ Weekly Firestore query timed out');
          throw TimeoutException('Firestore timeout');
        },
      );

      final result = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return TurnRecordedModel.fromJson(data);
      }).toList();

      // Cache the result
      _setToCache(cacheKey, result);
      log('Cached weekly data');

      return result;
    } catch (e) {
      log('Error fetching weekly data from Firebase: $e');
      return [];
    }
  }

  // Get all time rankings from Firebase (existing method renamed for clarity)
  Future<List<TurnRecordedModel>?> getAllTimeTurnedListFirebase(
      int limit) async {
    return await getTurnedListFirebase(limit);
  }

  // Convenient method to get data by period type
  Future<List<TurnRecordedModel>?> getTurnedListByPeriod(
      RankingPeriod period, int limit,
      {bool useFirebase = false, bool clearCache = false}) async {
    // Clear cache if requested (for refresh operations)
    if (clearCache) {
      _clearFirebaseCache();
    }

    switch (period) {
      case RankingPeriod.daily:
        return await getDailyTurnedListFirebase(limit) ??
            await getDailyTurnedList(limit);
      case RankingPeriod.weekly:
        return await getWeeklyTurnedListFirebase(limit) ??
            await getWeeklyTurnedList(limit);
      case RankingPeriod.all:
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
    // Skip Firebase upload in offline mode
    if (firebaseFirestore == null) {
      print('📱 Skipping Firebase upload (offline mode)');
      return true; // Return success for offline mode
    }

    try {
      await firebaseFirestore!
          .collection('turn_records')
          .add(item.toJson())
          .timeout(const Duration(seconds: 3), onTimeout: () {
        log('Timeout adding item to Firebase');
        throw TimeoutException('Firestore timeout');
      });

      // Clear cache after successful insert
      _clearFirebaseCache();

      log("inserted to Firebase database");

      return true;
    } catch (e) {
      log('Error adding item: $e');
      return false;
    }
  }
}
