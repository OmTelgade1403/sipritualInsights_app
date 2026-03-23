import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String id;
  final String type; // 'jap', 'meditation', 'journal'
  final int? count;
  final int? durationMinutes;
  final String? content; // for journal entries
  final String? mantra; // for jap
  final int pointsEarned;
  final DateTime timestamp;

  ActivityModel({
    required this.id,
    required this.type,
    this.count,
    this.durationMinutes,
    this.content,
    this.mantra,
    this.pointsEarned = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ActivityModel.fromMap(Map<String, dynamic> map, String id) {
    return ActivityModel(
      id: id,
      type: map['type'] ?? '',
      count: map['count'],
      durationMinutes: map['durationMinutes'],
      content: map['content'],
      mantra: map['mantra'],
      pointsEarned: map['pointsEarned'] ?? 0,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'count': count,
      'durationMinutes': durationMinutes,
      'content': content,
      'mantra': mantra,
      'pointsEarned': pointsEarned,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
