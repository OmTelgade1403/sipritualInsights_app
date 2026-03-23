import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../models/leaderboard_model.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/app_providers.dart';

/// Leaderboard screen with global and category tabs.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Leaderboard 🏆',
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'See how you compare with others',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _RankGraph(),
            const SizedBox(height: 24),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14),
                unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Global'),
                  Tab(text: 'My Category'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _GlobalLeaderboard(),
                  _CategoryLeaderboard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlobalLeaderboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(globalLeaderboardProvider);

    return leaderboardAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return _EmptyLeaderboard();
        }
        return _LeaderboardList(entries: entries);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => _EmptyLeaderboard(),
    );
  }
}

class _CategoryLeaderboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final category = user?.category ?? 'Adults';
    final leaderboardAsync = ref.watch(categoryLeaderboardProvider(category));

    return leaderboardAsync.when(
      data: (entries) {
        if (entries.isEmpty) return _EmptyLeaderboard();
        return _LeaderboardList(entries: entries);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => _EmptyLeaderboard(),
    );
  }
}

class _EmptyLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No rankings yet',
            style: GoogleFonts.outfit(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete activities to appear here!',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardList extends ConsumerWidget {
  final List<LeaderboardEntry> entries;
  const _LeaderboardList({required this.entries});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final rank = index + 1;
        return _LeaderboardTile(
          entry: entry, 
          rank: rank, 
          isCurrentUser: currentUser?.uid == entry.userId,
        );
      },
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isCurrentUser;
  const _LeaderboardTile({required this.entry, required this.rank, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank <= 3;
    final rankColors = [AppColors.secondary, Colors.grey.shade400, const Color(0xFFCD7F32)];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentUser 
          ? AppColors.primary.withOpacity(0.3)
          : isTopThree 
            ? rankColors[rank - 1].withOpacity(0.1) 
            : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primary 
              : isTopThree 
                ? rankColors[rank - 1].withOpacity(0.4) 
                : Colors.white.withOpacity(0.05),
          width: isCurrentUser ? 2 : (isTopThree ? 2 : 1),
        ),
        boxShadow: [
          if (isTopThree)
            BoxShadow(
              color: rankColors[rank - 1].withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isTopThree ? rankColors[rank - 1] : Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            boxShadow: [
              if (isTopThree)
                BoxShadow(
                  color: rankColors[rank - 1].withOpacity(0.4),
                  blurRadius: 8,
                ),
            ],
          ),
          child: Text(
            isTopThree ? ['🥇', '🥈', '🥉'][rank - 1] : '#$rank',
            style: GoogleFonts.outfit(
              fontSize: isTopThree ? 20 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // High contrast rank text
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.name,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: entry.progress,
                backgroundColor: Colors.white.withOpacity(0.05),
                valueColor: AlwaysStoppedAnimation(
                  isTopThree ? rankColors[rank - 1] : AppColors.secondary,
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const Icon(Icons.local_fire_department_rounded, size: 14, color: AppColors.error),
              const SizedBox(width: 4),
              Text(
                '${entry.streak} day streak',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${entry.score}',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isTopThree ? rankColors[rank - 1] : AppColors.gold,
              ),
            ),
            Text(
              'pts',
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankGraph extends StatelessWidget {
  const _RankGraph();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B1E54), Color(0xFF1A1230)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rank Progress',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Past 7 Days',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 5),
                      FlSpot(1, 4),
                      FlSpot(2, 6),
                      FlSpot(3, 3),
                      FlSpot(4, 2),
                      FlSpot(5, 4),
                      FlSpot(6, 1),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.gold],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary.withOpacity(0.2),
                          AppColors.gold.withOpacity(0.01),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
