import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  final String id;
  final String title;
  final String? audioUrl;
  final DateTime? scheduledTime; // For one-time play
  final int? hour; // For recurring
  final int? minute; // For recurring
  final List<int> repeatDays; // 1=Mon, 7=Sun
  final String? mantraName;
  final int japGoal;
  final bool isActive;
  final String type; // 'media' or 'jap'

  AlarmModel({
    required this.id,
    required this.title,
    this.audioUrl,
    this.scheduledTime,
    this.hour,
    this.minute,
    this.repeatDays = const [],
    this.mantraName,
    this.japGoal = 108,
    this.isActive = true,
    this.type = 'jap',
  });

  factory AlarmModel.fromMap(Map<String, dynamic> map, String id) {
    return AlarmModel(
      id: id,
      title: map['title'] ?? '',
      audioUrl: map['audioUrl'],
      scheduledTime: (map['scheduledTime'] as Timestamp?)?.toDate(),
      hour: map['hour'],
      minute: map['minute'],
      repeatDays: List<int>.from(map['repeatDays'] ?? []),
      mantraName: map['mantraName'],
      japGoal: map['japGoal'] ?? 108,
      isActive: map['isActive'] ?? true,
      type: map['type'] ?? 'jap',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'audioUrl': audioUrl,
      'scheduledTime': scheduledTime != null ? Timestamp.fromDate(scheduledTime!) : null,
      'hour': hour,
      'minute': minute,
      'repeatDays': repeatDays,
      'mantraName': mantraName,
      'japGoal': japGoal,
      'isActive': isActive,
      'type': type,
    };
  }

  String get timeString {
    if (scheduledTime != null) {
      final h = scheduledTime!.hour.toString().padLeft(2, '0');
      final m = scheduledTime!.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    if (hour != null && minute != null) {
      final h = hour!.toString().padLeft(2, '0');
      final m = minute!.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '--:--';
  }
}
