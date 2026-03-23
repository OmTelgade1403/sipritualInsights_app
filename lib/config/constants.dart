// ─── Gamification Constants ─────────────────────────────────────────────────

class PointValues {
  static const int jap = 10;
  static const int meditation = 15;
  static const int journal = 10;
  static const int dailyChallenge = 20;
  static const int streakBonus = 5;
}

class LevelThresholds {
  static const Map<int, String> levels = {
    0: 'Beginner',
    100: 'Seeker',
    300: 'Explorer',
    600: 'Yogi',
    1000: 'Master',
  };

  static String getLevelName(int score) {
    String level = 'Beginner';
    for (final entry in levels.entries) {
      if (score >= entry.key) {
        level = entry.value;
      }
    }
    return level;
  }

  static int getLevelIndex(int score) {
    int idx = 0;
    int i = 0;
    for (final entry in levels.entries) {
      if (score >= entry.key) idx = i;
      i++;
    }
    return idx;
  }

  static int getNextLevelScore(int score) {
    for (final entry in levels.entries) {
      if (score < entry.key) return entry.key;
    }
    return levels.keys.last;
  }
}

// ─── Badge Definitions ──────────────────────────────────────────────────────

class BadgeDefinition {
  final String id;
  final String name;
  final String description;
  final String icon;

  const BadgeDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

class Badges {
  static const List<BadgeDefinition> all = [
    BadgeDefinition(id: 'first_activity', name: 'First Step', description: 'Complete your first activity', icon: '🌱'),
    BadgeDefinition(id: 'streak_7', name: 'Dedicated Soul', description: '7-day streak', icon: '🔥'),
    BadgeDefinition(id: 'streak_30', name: 'Unwavering Spirit', description: '30-day streak', icon: '💎'),
    BadgeDefinition(id: 'jap_108', name: 'Sacred Count', description: 'Complete 108 Jap', icon: '📿'),
    BadgeDefinition(id: 'meditation_1hr', name: 'Deep Meditator', description: '1 hour total meditation', icon: '🧘'),
    BadgeDefinition(id: 'journal_10', name: 'Reflective Mind', description: 'Write 10 journal entries', icon: '📝'),
    BadgeDefinition(id: 'score_500', name: 'Rising Star', description: 'Reach 500 points', icon: '⭐'),
    BadgeDefinition(id: 'score_1000', name: 'Enlightened One', description: 'Reach 1000 points', icon: '✨'),
  ];
}

// ─── Category Constants ─────────────────────────────────────────────────────

class UserCategory {
  static const String kids = 'Kids';
  static const String teenagers = 'Teenagers';
  static const String adults = 'Adults';
  static const String seniors = 'Seniors';

  static const List<String> all = [kids, teenagers, adults, seniors];

  static const Map<String, String> ageRanges = {
    kids: '4–12 years',
    teenagers: '13–19 years',
    adults: '20–60 years',
    seniors: '60+ years',
  };

  static const Map<String, String> icons = {
    kids: '👶',
    teenagers: '🧑‍🎓',
    adults: '👨‍💼',
    seniors: '👴',
  };
}

// ─── Goals ───────────────────────────────────────────────────────────────────

class GoalOptions {
  static const List<String> all = [
    'Peace',
    'Focus',
    'Happiness',
    'Spiritual Growth',
  ];

  static const Map<String, String> icons = {
    'Peace': '🕊️',
    'Focus': '🎯',
    'Happiness': '😊',
    'Spiritual Growth': '🌿',
  };
}

// ─── Default Mantras ─────────────────────────────────────────────────────────

class DefaultMantras {
  static const List<Map<String, String>> mantras = [
    {'name': 'Om', 'description': 'Universal sound of creation'},
    {'name': 'Om Namah Shivaya', 'description': 'Salutations to Lord Shiva'},
    {'name': 'Om Mani Padme Hum', 'description': 'Jewel in the lotus'},
    {'name': 'Gayatri Mantra', 'description': 'Sacred verse of illumination'},
    {'name': 'Mahamrityunjaya', 'description': 'Great death-conquering mantra'},
    {'name': 'Custom', 'description': 'Enter your own mantra'},
  ];
}

// ─── Daily Quotes ────────────────────────────────────────────────────────────

class SpiritualQuotes {
  static const List<Map<String, String>> quotes = [
    {'quote': 'For one who has conquered his mind, a mind is best of friends, but for one who has failed to do so, a mind is the greatest enemy.', 'source': 'Bhagavad Gita 6.6'},
    {'quote': 'The soul is neither born, and nor does it die.', 'source': 'Bhagavad Gita 2.20'},
    {'quote': 'You have a right to perform your prescribed duty, but you are not entitled to the fruits of action.', 'source': 'Bhagavad Gita 2.47'},
    {'quote': 'A person achieves perfection by acting in whatever state he is placed, and dedicating his actions to the Supreme.', 'source': 'Bhagavad Gita 18.45'},
    {'quote': 'When meditation is mastered, the mind is unwavering like the flame of a lamp in a windless place.', 'source': 'Bhagavad Gita 6.19'},
    {'quote': 'He who has no attachments can really love others, for his love is pure and divine.', 'source': 'Bhagavad Gita'},
    {'quote': 'There is nothing lost or wasted in this life.', 'source': 'Bhagavad Gita 2.40'},
    {'quote': 'Truth is one, sages call it by various names.', 'source': 'Rig Veda'},
    {'quote': 'You are what your deep, driving desire is. As your desire is, so is your will. As your will is, so is your deed. As your deed is, so is your destiny.', 'source': 'Brihadaranyaka Upanishad'},
    {'quote': 'As the flowing rivers disappear in the sea, losing their name and form, thus a wise man, freed from name and form, goes to the divine person who is beyond all.', 'source': 'Mundaka Upanishad'},
    {'quote': 'By action alone did Janaka and others attain perfection.', 'source': 'Bhagavad Gita 3.20'},
    {'quote': 'Whenever dharma declines and the purpose of life is forgotten, I manifest myself on earth.', 'source': 'Bhagavad Gita 4.7'},
    {'quote': 'Like two birds of golden plumage, inseparable companions, the individual self and the immortal Self are perched on the branches of the selfsame tree.', 'source': 'Shvetashvatara Upanishad'},
    {'quote': 'He who sees all beings in his own Self, and his own Self in all beings, loses all fear.', 'source': 'Isha Upanishad'},
    {'quote': 'There is no friend like patience, no enemy like anger.', 'source': 'Ramayana'},
    {'quote': 'Sorrow can destroy everything; sorrow kills energy, sorrow kills the mind.', 'source': 'Ramayana'},
    {'quote': 'To a hero, danger is an inspiration.', 'source': 'Mahabharata'},
    {'quote': 'Action goes with the doer; it does not disappear.', 'source': 'Mahabharata'},
  ];

  static Map<String, String> getDailyQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return quotes[dayOfYear % quotes.length];
  }
}

// ─── Journal Prompts ─────────────────────────────────────────────────────────

class JournalPrompts {
  static const List<String> prompts = [
    'What are you grateful for today?',
    'Describe a moment of peace you experienced recently.',
    'What spiritual lesson did life teach you this week?',
    'How did you show kindness to someone today?',
    'What does inner peace mean to you?',
    'Write about a challenge you overcame with faith.',
    'What mantra or thought gives you strength?',
    'Describe your ideal day of spiritual practice.',
    'What emotions are you holding onto that you can release?',
    'How has meditation changed your perspective?',
    'Write a letter to your future self about your spiritual journey.',
    'What does forgiveness mean to you?',
    'Describe a moment when you felt truly connected to the universe.',
    'What habits support your spiritual growth?',
    'How do you find balance between material and spiritual life?',
  ];

  static String getDailyPrompt() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return prompts[dayOfYear % prompts.length];
  }
}
