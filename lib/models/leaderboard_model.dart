class LeaderboardEntry {
  final String userId;
  final String name;
  final String? photoUrl;
  final String? category;
  final int score;
  final int streak;
  final int rank;
  final double progress;

  LeaderboardEntry({
    required this.userId,
    required this.name,
    this.photoUrl,
    this.category,
    required this.score,
    required this.streak,
    this.rank = 0,
    this.progress = 0.0,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      category: map['category'],
      score: map['score'] ?? 0,
      streak: map['streak'] ?? 0,
      progress: (map['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'photoUrl': photoUrl,
      'category': category,
      'score': score,
      'streak': streak,
      'progress': progress,
    };
  }
}
