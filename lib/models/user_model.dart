import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final int? age;
  final String? category;
  final List<String> goals;
  final int score;
  final int streak;
  final int level;
  final List<String> badges;
  final int japCount;
  final double overallProgress;
  final DateTime createdAt;
  final DateTime? lastActiveDate;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.age,
    this.category,
    this.goals = const [],
    this.score = 0,
    this.streak = 0,
    this.level = 0,
    this.badges = const [],
    this.japCount = 0,
    this.overallProgress = 0.0,
    DateTime? createdAt,
    this.lastActiveDate,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      age: map['age'],
      category: map['category'],
      goals: List<String>.from(map['goals'] ?? []),
      score: map['score'] ?? 0,
      streak: map['streak'] ?? 0,
      level: map['level'] ?? 0,
      badges: List<String>.from(map['badges'] ?? []),
      japCount: map['japCount'] ?? 0,
      overallProgress: (map['overallProgress'] ?? 0.0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActiveDate: (map['lastActiveDate'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'age': age,
      'category': category,
      'goals': goals,
      'score': score,
      'streak': streak,
      'level': level,
      'badges': badges,
      'japCount': japCount,
      'overallProgress': overallProgress,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActiveDate': lastActiveDate != null ? Timestamp.fromDate(lastActiveDate!) : null,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    int? age,
    String? category,
    List<String>? goals,
    int? score,
    int? streak,
    int? level,
    List<String>? badges,
    int? japCount,
    double? overallProgress,
    DateTime? lastActiveDate,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      category: category ?? this.category,
      goals: goals ?? this.goals,
      score: score ?? this.score,
      streak: streak ?? this.streak,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      japCount: japCount ?? this.japCount,
      overallProgress: overallProgress ?? this.overallProgress,
      createdAt: createdAt,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
