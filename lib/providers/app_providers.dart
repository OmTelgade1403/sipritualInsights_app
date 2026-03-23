import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/activity_model.dart';
import '../models/book_model.dart';
import '../models/alarm_model.dart';
import '../models/leaderboard_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/local_db_service.dart';
import '../services/gamification_service.dart';
import '../services/book_service.dart';
import '../services/alarm_service.dart';

// ─── Service Providers ──────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());
final localDBServiceProvider = Provider<LocalDBService>((ref) => LocalDBService());
final gamificationServiceProvider = Provider<GamificationService>((ref) => GamificationService());
final bookServiceProvider = Provider<BookService>((ref) => BookService());
final alarmServiceProvider = Provider<AlarmService>((ref) => AlarmService());

// ─── Auth State Provider ────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

// ─── Current User Provider ──────────────────────────────────────────────────

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserModel?>>((ref) {
  return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;

  CurrentUserNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _ref.listen(authStateProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            _loadUser(user.uid);
          } else {
            state = const AsyncValue.data(null);
          }
        },
        loading: () => state = const AsyncValue.loading(),
        error: (e, s) => state = AsyncValue.error(e, s),
      );
    });
  }

  Future<void> _loadUser(String uid) async {
    try {
      final user = await _ref.read(firestoreServiceProvider).getUser(uid);
      state = AsyncValue.data(user);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> refreshUser() async {
    final firebaseUser = _ref.read(authServiceProvider).currentUser;
    if (firebaseUser != null) {
      await _loadUser(firebaseUser.uid);
    }
  }

  void setUser(UserModel user) {
    state = AsyncValue.data(user);
  }
}

// ─── Theme Provider ─────────────────────────────────────────────────────────

final isDarkModeProvider = StateProvider<bool>((ref) => false);

// ─── Today's Activities Provider ────────────────────────────────────────────

final todayActivitiesProvider = FutureProvider<List<ActivityModel>>((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];
  return ref.read(firestoreServiceProvider).getActivitiesForDate(user.uid, DateTime.now());
});

// ─── Leaderboard Providers (Live Stream) ───────────────────────────────────

final globalLeaderboardProvider = StreamProvider<List<LeaderboardEntry>>((ref) {
  return ref.read(firestoreServiceProvider).streamGlobalLeaderboard();
});

final categoryLeaderboardProvider = StreamProvider.family<List<LeaderboardEntry>, String>((ref, category) {
  return ref.read(firestoreServiceProvider).streamCategoryLeaderboard(category);
});

// ─── Navigation Index Provider ──────────────────────────────────────────────

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// ─── Alarms Provider ────────────────────────────────────────────────────────

final alarmsProvider = StreamProvider<List<AlarmModel>>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value([]);
  return ref.read(firestoreServiceProvider).streamAlarms(user.uid);
});
// ─── Books Providers ────────────────────────────────────────────────────────

final booksProvider = FutureProvider<List<BookModel>>((ref) async {
  return ref.read(bookServiceProvider).getBooks();
});

final booksByDeityProvider = FutureProvider.family<List<BookModel>, String>((ref, deity) async {
  return ref.read(bookServiceProvider).getBooksByDeity(deity);
});
