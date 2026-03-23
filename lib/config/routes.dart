import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/profile/profile_setup_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/jap/jap_counter_screen.dart';
import '../screens/meditation/meditation_screen.dart';
import '../screens/journal/journal_screen.dart';
import '../screens/leaderboard/leaderboard_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/media/media_screen.dart';
import '../screens/books/books_screen.dart';
import '../screens/books/book_reader_screen.dart';
import '../screens/explore/story_reader_screen.dart';
import '../screens/explore/game_demo_screen.dart';
import '../screens/ai/ai_chat_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    // Main app shell with bottom navigation
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ExploreScreen(),
          ),
        ),
        GoRoute(
          path: '/leaderboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LeaderboardScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    // Full-screen routes (no bottom nav)
    GoRoute(
      path: '/jap',
      builder: (context, state) => const JapCounterScreen(),
    ),
    GoRoute(
      path: '/meditation',
      builder: (context, state) => const MeditationScreen(),
    ),
    GoRoute(
      path: '/journal',
      builder: (context, state) => const JournalScreen(),
    ),
    GoRoute(
      path: '/media',
      builder: (context, state) => const MediaScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/books',
      builder: (context, state) => const BooksScreen(),
    ),
    GoRoute(
      path: '/book-reader/:bookId',
      builder: (context, state) {
        final bookId = state.pathParameters['bookId']!;
        return BookReaderScreen(bookId: bookId);
      },
    ),
    GoRoute(
      path: '/story',
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? 'Spiritual Story';
        return StoryReaderScreen(title: title);
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const MantraMatchGame(),
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) => const AIChatScreen(),
    ),
  ],
);
