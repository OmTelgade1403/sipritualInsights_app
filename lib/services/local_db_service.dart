import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/activity_model.dart';
import '../models/alarm_model.dart';
import '../models/leaderboard_model.dart';

/// Local implementation to bypass Firebase billing issues.
class LocalDBService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _userControllers = <String, StreamController<UserModel?>>{};
  final _activitiesControllers = <String, StreamController<List<ActivityModel>>>{};
  final _alarmsControllers = <String, StreamController<List<AlarmModel>>>{};

  // ─── Helper method for JSON Serialization ───────────────────────────────

  Map<String, dynamic> _sanitize(Map<String, dynamic> map) {
    final sanitized = Map<String, dynamic>.from(map);
    for (final key in sanitized.keys.toList()) {
      final value = sanitized[key];
      if (value is Timestamp) {
        sanitized[key] = value.toDate().toIso8601String();
      } else if (value is DateTime) {
        sanitized[key] = value.toIso8601String();
      }
    }
    return sanitized;
  }

  // ─── User Operations ────────────────────────────────────────────────────

  Future<void> createUser(UserModel user) async {
    final prefs = await _prefs;
    final map = _sanitize(user.toMap());
    final data = jsonEncode(map);
    await prefs.setString('user_${user.uid}', data);
    _emitUser(user.uid, user);
  }

  Future<UserModel?> getUser(String uid) async {
    final prefs = await _prefs;
    final data = prefs.getString('user_$uid');
    if (data != null) {
      final map = jsonDecode(data);
      if (map['lastActiveDate'] is String) {
        map['lastActiveDate'] = Timestamp.fromDate(DateTime.parse(map['lastActiveDate']));
      }
      if (map['createdAt'] is String) {
        map['createdAt'] = Timestamp.fromDate(DateTime.parse(map['createdAt']));
      }
      return UserModel.fromMap(map, uid);
    }
    return null;
  }

  Stream<UserModel?> streamUser(String uid) {
    if (!_userControllers.containsKey(uid)) {
      _userControllers[uid] = StreamController<UserModel?>.broadcast();
      getUser(uid).then((user) => _userControllers[uid]!.add(user));
    }
    return _userControllers[uid]!.stream;
  }

  void _emitUser(String uid, UserModel user) {
    if (_userControllers.containsKey(uid)) {
      _userControllers[uid]!.add(user);
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    final user = await getUser(uid);
    if (user != null) {
      final currentMap = user.toMap();
      currentMap.addAll(data);
      final updatedUser = UserModel.fromMap(currentMap, uid);
      await createUser(updatedUser);
    }
  }

  Future<void> updateUserStats(String uid, {int? score, int? streak, int? level, List<String>? badges}) async {
    final user = await getUser(uid);
    if (user != null) {
      final data = <String, dynamic>{};
      if (score != null) data['score'] = score;
      if (streak != null) data['streak'] = streak;
      if (level != null) data['level'] = level;
      if (badges != null) data['badges'] = badges;
      data['lastActiveDate'] = Timestamp.now();
      await updateUser(uid, data);
    }
  }

  // ─── Activity Operations ────────────────────────────────────────────────

  Future<List<ActivityModel>> _getAllActivities(String uid) async {
    final prefs = await _prefs;
    final keys = prefs.getKeys().where((k) => k.startsWith('activity_${uid}_'));
    final activities = <ActivityModel>[];
    for (final key in keys) {
      final data = prefs.getString(key);
      if (data != null) {
        final map = jsonDecode(data);
        if (map['timestamp'] is String) {
          map['timestamp'] = Timestamp.fromDate(DateTime.parse(map['timestamp']));
        }
        activities.add(ActivityModel.fromMap(map, map['id'] ?? ''));
      }
    }
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities;
  }

  Future<void> saveActivity(String uid, ActivityModel activity) async {
    final prefs = await _prefs;
    final map = _sanitize(activity.toMap());
    await prefs.setString('activity_${uid}_${activity.id}', jsonEncode(map));
    _emitActivities(uid);
  }

  Future<List<ActivityModel>> getActivitiesForDate(String uid, DateTime date) async {
    final all = await _getAllActivities(uid);
    return all.where((a) => a.timestamp.year == date.year && a.timestamp.month == date.month && a.timestamp.day == date.day).toList();
  }

  Stream<List<ActivityModel>> streamTodayActivities(String uid) {
    if (!_activitiesControllers.containsKey(uid)) {
      _activitiesControllers[uid] = StreamController<List<ActivityModel>>.broadcast();
      _emitActivities(uid);
    }
    return _activitiesControllers[uid]!.stream;
  }

  Future<void> _emitActivities(String uid) async {
    if (_activitiesControllers.containsKey(uid)) {
      final today = DateTime.now();
      final activities = await getActivitiesForDate(uid, today);
      _activitiesControllers[uid]!.add(activities);
    }
  }

  Future<List<ActivityModel>> getActivities(String uid, {int limit = 20, dynamic lastDoc}) async {
    final all = await _getAllActivities(uid);
    return all.take(limit).toList();
  }

  // ─── Alarm Operations ───────────────────────────────────────────────────

  Future<List<AlarmModel>> _getAllAlarms(String uid) async {
    final prefs = await _prefs;
    final keys = prefs.getKeys().where((k) => k.startsWith('alarm_${uid}_'));
    final alarms = <AlarmModel>[];
    for (final key in keys) {
      final data = prefs.getString(key);
      if (data != null) {
        final map = jsonDecode(data);
        if (map['scheduledTime'] is String) {
          map['scheduledTime'] =
              Timestamp.fromDate(DateTime.parse(map['scheduledTime']));
        }
        alarms.add(AlarmModel.fromMap(map, map['id'] ?? ''));
      }
    }
    return alarms;
  }

  Future<void> saveAlarm(String uid, AlarmModel alarm) async {
    final prefs = await _prefs;
    final map = _sanitize(alarm.toMap());
    await prefs.setString('alarm_${uid}_${alarm.id}', jsonEncode(map));
    _emitAlarms(uid);
  }

  Stream<List<AlarmModel>> streamAlarms(String uid) {
    if (!_alarmsControllers.containsKey(uid)) {
      _alarmsControllers[uid] = StreamController<List<AlarmModel>>.broadcast();
      _emitAlarms(uid);
    }
    return _alarmsControllers[uid]!.stream;
  }

  Future<void> _emitAlarms(String uid) async {
    if (_alarmsControllers.containsKey(uid)) {
      final alarms = await _getAllAlarms(uid);
      _alarmsControllers[uid]!.add(alarms);
    }
  }

  Future<void> deleteAlarm(String uid, String alarmId) async {
    final prefs = await _prefs;
    await prefs.remove('alarm_${uid}_$alarmId');
    _emitAlarms(uid);
  }

  // ─── Leaderboard Operations ─────────────────────────────────────────────

  Future<void> updateLeaderboard(String uid, LeaderboardEntry entry) async {
    final prefs = await _prefs;
    final map = _sanitize(entry.toMap());
    await prefs.setString('leaderboard_$uid', jsonEncode(map));
  }

  Future<List<LeaderboardEntry>> getGlobalLeaderboard({int limit = 50}) async {
    final prefs = await _prefs;
    final keys = prefs.getKeys().where((k) => k.startsWith('leaderboard_'));
    final entries = <LeaderboardEntry>[];
    
    for (final key in keys) {
      final data = prefs.getString(key);
      if (data != null) {
        entries.add(LeaderboardEntry.fromMap(jsonDecode(data)));
      }
    }

    // Add mock entries if fewer than 5 exist to give a "community" feel
    if (entries.length < 5) {
      final mocks = [
        LeaderboardEntry(userId: 'm1', name: 'Ishaan Sharma', photoUrl: 'https://i.pravatar.cc/150?u=m1', category: 'Adults', score: 1250, streak: 12),
        LeaderboardEntry(userId: 'm2', name: 'Ananya Iyer', photoUrl: 'https://i.pravatar.cc/150?u=m2', category: 'Teenagers', score: 980, streak: 8),
        LeaderboardEntry(userId: 'm3', name: 'Kabir Das', photoUrl: 'https://i.pravatar.cc/150?u=m3', category: 'Seniors', score: 2100, streak: 45),
        LeaderboardEntry(userId: 'm4', name: 'Aarav Gupta', photoUrl: 'https://i.pravatar.cc/150?u=m4', category: 'Kids', score: 450, streak: 5),
        LeaderboardEntry(userId: 'm5', name: 'Priya Mehra', photoUrl: 'https://i.pravatar.cc/150?u=m5', category: 'Adults', score: 870, streak: 3),
      ];
      entries.addAll(mocks);
    }

    entries.sort((a, b) => b.score.compareTo(a.score));
    
    // Assign ranks
    for (var i = 0; i < entries.length; i++) {
       final e = entries[i];
       entries[i] = LeaderboardEntry(userId: e.userId, name: e.name, photoUrl: e.photoUrl, category: e.category, score: e.score, streak: e.streak, rank: i + 1);
    }
    
    return entries.take(limit).toList();
  }

  Future<List<LeaderboardEntry>> getCategoryLeaderboard(String category, {int limit = 50}) async {
    final global = await getGlobalLeaderboard(limit: 1000);
    return global.where((e) => e.category == category).take(limit).toList();
  }

  // ─── Journal Operations ─────────────────────────────────────────────────

  Future<List<ActivityModel>> getJournalEntries(String uid, {int limit = 20}) async {
    final all = await _getAllActivities(uid);
    return all.where((a) => a.type == 'journal').take(limit).toList();
  }
}
