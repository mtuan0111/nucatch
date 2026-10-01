abstract class TurnRecordedListEvent {}

enum RankingPeriod {
  daily,
  weekly,
  all,
}

extension RankingPeriodExtension on RankingPeriod {
  String get value {
    switch (this) {
      case RankingPeriod.daily:
        return 'daily';
      case RankingPeriod.weekly:
        return 'weekly';
      case RankingPeriod.all:
        return 'all';
    }
  }

  static RankingPeriod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'daily':
        return RankingPeriod.daily;
      case 'weekly':
        return RankingPeriod.weekly;
      case 'all':
      default:
        return RankingPeriod.all;
    }
  }
}

class LoadData extends TurnRecordedListEvent {}

class LoadDataByPeriod extends TurnRecordedListEvent {
  final RankingPeriod period; // Now using enum instead of String
  final bool useFirebase;
  final bool isRefresh; // New parameter for refresh operations
  final String? userId; // Filter by user ID if provided

  LoadDataByPeriod({
    required this.period,
    this.useFirebase = true,
    this.isRefresh = false, // Default to false for non-refresh operations
    this.userId, // Optional user ID for filtering
  });
}

// class AddItem extends TurnRecordedListEvent {
//   final TurnRecordedModel item;
//   int? index;

//   AddItem({required this.item});
// }

class RemoveItem extends TurnRecordedListEvent {}

class ChangeNumberOfTopBoard extends TurnRecordedListEvent {
  final int numberOfTopBoard;

  ChangeNumberOfTopBoard({required this.numberOfTopBoard});
}

// Debug event to help troubleshoot date filtering
class DebugDatabaseContent extends TurnRecordedListEvent {}

/// Screenshot/demo-only event: replaces the leaderboard's contents with a
/// curated, deterministic set of rows so the store-screenshot capture
/// (`integration_test/store_screenshots_test.dart`) never puts real players'
/// usernames on a marketing frame. Not dispatched anywhere in the shipping app
/// — only from the screenshot walkthrough. See `tool/screenshots/README.md`.
class SeedDemoLeaderboard extends TurnRecordedListEvent {}
