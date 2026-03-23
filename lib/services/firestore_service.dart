import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/activity_model.dart';
import '../models/alarm_model.dart';
import '../models/leaderboard_model.dart';

/// Service handling all Firestore database operations.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── User Operations ────────────────────────────────────────────────────

  /// Create or update user document
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  /// Get user document
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, uid);
    }
    return null;
  }

  /// Stream user document
  Stream<UserModel?> streamUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, uid);
      }
      return null;
    });
  }

  /// Update user fields
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  /// Update user score, streak, and level
  Future<void> updateUserStats(String uid, {int? score, int? streak, int? level, List<String>? badges, int? japCount, double? progress, List<String>? goals}) async {
    final data = <String, dynamic>{};
    if (score != null) data['score'] = score;
    if (streak != null) data['streak'] = streak;
    if (level != null) data['level'] = level;
    if (badges != null) data['badges'] = badges;
    if (japCount != null) data['japCount'] = japCount;
    if (progress != null) data['overallProgress'] = progress;
    if (goals != null) data['goals'] = goals;
    data['lastActiveDate'] = Timestamp.now();
    await _db.collection('users').doc(uid).update(data);
  }

  // ─── Activity Operations ────────────────────────────────────────────────

  /// Save activity
  Future<void> saveActivity(String uid, ActivityModel activity) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .doc(activity.id)
        .set(activity.toMap());
  }

  /// Get activities for a date
  Future<List<ActivityModel>> getActivitiesForDate(String uid, DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end))
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Stream today's activities
  Stream<List<ActivityModel>> streamTodayActivities(String uid) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    return _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Get all activities (paginated)
  Future<List<ActivityModel>> getActivities(String uid, {int limit = 20, DocumentSnapshot? lastDoc}) async {
    var query = _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // ─── Alarm Operations ───────────────────────────────────────────────────

  /// Save alarm
  Future<void> saveAlarm(String uid, AlarmModel alarm) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('alarms')
        .doc(alarm.id)
        .set(alarm.toMap());
  }

  /// Get alarms
  Stream<List<AlarmModel>> streamAlarms(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('alarms')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AlarmModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Delete alarm
  Future<void> deleteAlarm(String uid, String alarmId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('alarms')
        .doc(alarmId)
        .delete();
  }

  // ─── Leaderboard Operations ─────────────────────────────────────────────

  /// Update leaderboard entry
  Future<void> updateLeaderboard(String uid, LeaderboardEntry entry) async {
    await _db.collection('leaderboard').doc(uid).set(entry.toMap());
  }

  /// Get global leaderboard (top 50)
  Future<List<LeaderboardEntry>> getGlobalLeaderboard({int limit = 50}) async {
    final snapshot = await _db
        .collection('users')
        .orderBy('score', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.asMap().entries.map((e) {
      final user = UserModel.fromMap(e.value.data(), e.value.id);
      return LeaderboardEntry(
        userId: user.uid,
        name: user.name.isEmpty ? 'Spiritual Seeker' : user.name,
        photoUrl: user.photoUrl,
        category: user.category,
        score: user.score,
        streak: user.streak,
        progress: user.overallProgress,
        rank: e.key + 1,
      );
    }).toList();
  }

  /// Get category leaderboard
  Future<List<LeaderboardEntry>> getCategoryLeaderboard(String category, {int limit = 50}) async {
    final snapshot = await _db
        .collection('users')
        .where('category', isEqualTo: category)
        .orderBy('score', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.asMap().entries.map((e) {
      final user = UserModel.fromMap(e.value.data(), e.value.id);
      return LeaderboardEntry(
        userId: user.uid,
        name: user.name.isEmpty ? 'Spiritual Seeker' : user.name,
        photoUrl: user.photoUrl,
        category: user.category,
        score: user.score,
        streak: user.streak,
        progress: user.overallProgress,
        rank: e.key + 1,
      );
    }).toList();
  }

  /// Stream global leaderboard – live updates whenever any user's score changes
  Stream<List<LeaderboardEntry>> streamGlobalLeaderboard({int limit = 50}) {
    return _db
        .collection('users')
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.asMap().entries.map((e) {
              final user = UserModel.fromMap(e.value.data(), e.value.id);
              return LeaderboardEntry(
                userId: user.uid,
                name: user.name.isEmpty ? 'Spiritual Seeker' : user.name,
                photoUrl: user.photoUrl,
                category: user.category,
                score: user.score,
                streak: user.streak,
                progress: user.overallProgress,
                rank: e.key + 1,
              );
            }).toList());
  }

  /// Stream category leaderboard – live updates
  Stream<List<LeaderboardEntry>> streamCategoryLeaderboard(String category, {int limit = 50}) {
    return _db
        .collection('users')
        .where('category', isEqualTo: category)
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.asMap().entries.map((e) {
              final user = UserModel.fromMap(e.value.data(), e.value.id);
              return LeaderboardEntry(
                userId: user.uid,
                name: user.name.isEmpty ? 'Spiritual Seeker' : user.name,
                photoUrl: user.photoUrl,
                category: user.category,
                score: user.score,
                streak: user.streak,
                progress: user.overallProgress,
                rank: e.key + 1,
              );
            }).toList());
  }

  // ─── Journal Operations ─────────────────────────────────────────────────

  /// Get journal entries
  Future<List<ActivityModel>> getJournalEntries(String uid, {int limit = 20}) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('activities')
        .where('type', isEqualTo: 'journal')
        .get();

    final docs = snapshot.docs
        .map((doc) => ActivityModel.fromMap(doc.data(), doc.id))
        .toList();
        
    docs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return docs.take(limit).toList();
  }
}
