import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/models/turn_record_model.dart';

class TurnRecordedServices {
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

  /// Generic method to query Firestore with automatic cache fallback
  /// Tries server first with 5-second timeout, then falls back to cache
  Future<List<TurnRecordedModel>> _queryFirestore({
    required String cacheKey,
    required Query<Map<String, dynamic>> query,
    required String queryType,
  }) async {
    // Check in-memory cache first
    final cachedData = _getFromCache(cacheKey);
    if (cachedData != null) {
      log('Returning cached $queryType data');
      return cachedData;
    }

    // Firestore not available
    if (firebaseFirestore == null) {
      print('⚠️ Firestore not initialized');
      return [];
    }

    try {
      // Try to get from server first with 5-second timeout
      try {
        final querySnapshot = await query.get().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            log('⏱️ $queryType server query timed out - fetching from cache');
            throw TimeoutException('Server timeout');
          },
        );

        final result = querySnapshot.docs
            .map((doc) => TurnRecordedModel.fromJson(doc.data()))
            .toList();

        // Cache the result
        _setToCache(cacheKey, result);
        log('✅ Fetched from server and cached $queryType data');

        return result;
      } on TimeoutException {
        // Server timed out, try to get from cache
        log('📱 Fetching $queryType data from offline cache');
        final querySnapshot =
            await query.get(const GetOptions(source: Source.cache));

        final result = querySnapshot.docs
            .map((doc) => TurnRecordedModel.fromJson(doc.data()))
            .toList();

        log('✅ Returned ${result.length} $queryType items from cache');
        return result;
      }
    } catch (e) {
      log('⚠️ Error fetching $queryType data from Firestore: $e');
      return [];
    }
  }

  Future<List<TurnRecordedModel>?> getTurnedListFirebase(int limit) async {
    final query = firebaseFirestore!
        .collection('turn_records')
        .orderBy(PreferencesKey.POINT, descending: true)
        .orderBy(PreferencesKey.RECORDED_TIME)
        .limit(limit);

    return _queryFirestore(
      cacheKey: 'all_time_$limit',
      query: query,
      queryType: 'all-time',
    );
  }

  Future<List<TurnRecordedModel>?> getDailyTurnedListFirebase(int limit) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final startOfDayMillis = startOfDay.millisecondsSinceEpoch;
    final endOfDayMillis = endOfDay.millisecondsSinceEpoch;

    final query = firebaseFirestore!
        .collection('turn_records')
        .where(PreferencesKey.RECORDED_TIME,
            isGreaterThanOrEqualTo: startOfDayMillis)
        .where(PreferencesKey.RECORDED_TIME, isLessThan: endOfDayMillis)
        .orderBy(PreferencesKey.POINT, descending: true)
        .orderBy(PreferencesKey.RECORDED_TIME)
        .limit(limit);

    return _queryFirestore(
      cacheKey: 'daily_${startOfDayMillis}_$limit',
      query: query,
      queryType: 'daily',
    );
  }

  Future<List<TurnRecordedModel>?> getWeeklyTurnedListFirebase(
      int limit) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final weekAgoMillis = weekAgo.millisecondsSinceEpoch;

    final query = firebaseFirestore!
        .collection('turn_records')
        .where(PreferencesKey.RECORDED_TIME,
            isGreaterThanOrEqualTo: weekAgoMillis)
        .orderBy(PreferencesKey.POINT, descending: true)
        .orderBy(PreferencesKey.RECORDED_TIME)
        .limit(limit);

    return _queryFirestore(
      cacheKey: 'weekly_${weekAgoMillis}_$limit',
      query: query,
      queryType: 'weekly',
    );
  }

  Future<List<TurnRecordedModel>?> getAllTimeTurnedListFirebase(
      int limit) async {
    return await getTurnedListFirebase(limit);
  }

  Future<List<TurnRecordedModel>?> getTurnedListByPeriod(
      RankingPeriod period, int limit,
      {bool useFirebase = false, bool clearCache = false}) async {
    // Clear cache if requested (for refresh operations)
    if (clearCache) {
      _clearFirebaseCache();
    }

    // With Firestore offline persistence, we only need to query Firestore
    // It will automatically use cached data when offline
    switch (period) {
      case RankingPeriod.daily:
        return await getDailyTurnedListFirebase(limit) ?? [];
      case RankingPeriod.weekly:
        return await getWeeklyTurnedListFirebase(limit) ?? [];
      case RankingPeriod.all:
        return await getAllTimeTurnedListFirebase(limit) ?? [];
    }
  }

  Future<bool> addItemToFirebase(TurnRecordedModel item) async {
    // Skip Firebase upload if Firestore is not available
    if (firebaseFirestore == null) {
      print('📱 Skipping Firebase upload (Firestore not available)');
      return false;
    }

    try {
      // With offline persistence enabled, this will queue the write if offline
      // and automatically sync when back online
      // Timeout after 5 seconds to avoid blocking UI
      await firebaseFirestore!
          .collection('turn_records')
          .add(item.toJson())
          .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          log('⏱️ Write timed out - queued for offline sync');
          throw TimeoutException('Queued for sync');
        },
      );

      // Clear cache after successful insert
      _clearFirebaseCache();

      log("✅ Inserted to Firestore (or queued if offline)");

      return true;
    } catch (e) {
      // Even on timeout, Firestore offline persistence may have queued it
      log('⚠️ Error adding item to Firestore: $e');
      // Return true if it's a timeout - offline persistence likely queued it
      if (e is TimeoutException) {
        log('📱 Item queued for offline sync');
        return true;
      }
      return false;
    }
  }
}
