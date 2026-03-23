import '../config/constants.dart';
import '../models/user_model.dart';
import '../models/leaderboard_model.dart';
import 'firestore_service.dart';

/// Service handling all gamification logic: points, streaks, levels, badges.
class GamificationService {
  final FirestoreService _firestoreService = FirestoreService();

  /// Award points for an activity and update user stats
  Future<UserModel> awardPoints(UserModel user, String activityType) async {
    int points = 0;
    switch (activityType) {
      case 'jap':
        points = PointValues.jap;
        break;
      case 'meditation':
        points = PointValues.meditation;
        break;
      case 'journal':
        points = PointValues.journal;
        break;
      case 'daily_challenge':
        points = PointValues.dailyChallenge;
        break;
    }

    final newScore = user.score + points;
    final newLevel = LevelThresholds.getLevelIndex(newScore);
    final newStreak = _calculateStreak(user);
    final newBadges = _checkBadges(user, newScore, newStreak, activityType);

    // Add streak bonus
    final totalPoints = points + (newStreak > 0 ? PointValues.streakBonus : 0);
    final finalScore = user.score + totalPoints;

    final updatedUser = user.copyWith(
      score: finalScore,
      level: newLevel,
      streak: newStreak,
      badges: newBadges,
      lastActiveDate: DateTime.now(),
    );

    // Update Firestore
    await _firestoreService.updateUserStats(
      user.uid,
      score: finalScore,
      streak: newStreak,
      level: newLevel,
      badges: newBadges,
    );

    // Update leaderboard
    await _firestoreService.updateLeaderboard(
      user.uid,
      LeaderboardEntry(
        userId: user.uid,
        name: user.name,
        photoUrl: user.photoUrl,
        category: user.category,
        score: finalScore,
        streak: newStreak,
      ),
    );

    return updatedUser;
  }

  /// Calculate streak based on last active date
  int _calculateStreak(UserModel user) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (user.lastActiveDate == null) return 1;

    final lastActive = DateTime(
      user.lastActiveDate!.year,
      user.lastActiveDate!.month,
      user.lastActiveDate!.day,
    );

    final difference = today.difference(lastActive).inDays;

    if (difference == 0) {
      return user.streak; // Same day, no change
    } else if (difference == 1) {
      return user.streak + 1; // Consecutive day
    } else {
      return 1; // Streak broken, reset
    }
  }

  /// Check and award new badges
  List<String> _checkBadges(UserModel user, int newScore, int newStreak, String activityType) {
    final badges = List<String>.from(user.badges);

    // First activity badge
    if (!badges.contains('first_activity')) {
      badges.add('first_activity');
    }

    // Streak badges
    if (newStreak >= 7 && !badges.contains('streak_7')) {
      badges.add('streak_7');
    }
    if (newStreak >= 30 && !badges.contains('streak_30')) {
      badges.add('streak_30');
    }

    // Score badges
    if (newScore >= 500 && !badges.contains('score_500')) {
      badges.add('score_500');
    }
    if (newScore >= 1000 && !badges.contains('score_1000')) {
      badges.add('score_1000');
    }

    return badges;
  }

  /// Get level name for a score
  String getLevelName(int score) => LevelThresholds.getLevelName(score);

  /// Get progress to next level (0.0 to 1.0)
  double getLevelProgress(int score) {
    final currentLevelScore = _getCurrentLevelScore(score);
    final nextLevelScore = LevelThresholds.getNextLevelScore(score);

    if (nextLevelScore == currentLevelScore) return 1.0;

    return (score - currentLevelScore) / (nextLevelScore - currentLevelScore);
  }

  int _getCurrentLevelScore(int score) {
    int current = 0;
    for (final entry in LevelThresholds.levels.entries) {
      if (score >= entry.key) current = entry.key;
    }
    return current;
  }
}
