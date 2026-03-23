import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/app_providers.dart';
import '../../widgets/glass_card.dart';

/// Home dashboard with daily insight, tasks, stats, and quick actions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final dailyQuote = SpiritualQuotes.getDailyQuote();

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          data: (user) {
            final userName = user?.name ?? 'Seeker';
            final score = user?.score ?? 0;
            final streak = user?.streak ?? 0;
            final levelName = LevelThresholds.getLevelName(score);

            final activitiesAsync = ref.watch(todayActivitiesProvider);
            final dailyJapCount = activitiesAsync.when(
              data: (activities) => activities
                  .where((a) => a.type == 'jap')
                  .fold(0, (sum, a) => sum + (a.count ?? 0)),
              loading: () => 0,
              error: (_, __) => 0,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ─── Greeting Header ─────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Namaste 🙏',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push('/settings'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.settings_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── Daily Insight Card ──────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B1E54), Color(0xFF1A1230)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Icon(
                            Icons.auto_awesome,
                            size: 150,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                                ),
                                child: Text(
                                  'DAILY INSIGHT',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.gold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '"${dailyQuote['quote']}"',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.4,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    height: 1,
                                    width: 30,
                                    color: AppColors.gold.withOpacity(0.5),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    dailyQuote['source'] ?? 'Sacred Text',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Stats Row ───────────────────────────────────────
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.stars_rounded,
                        label: 'Score',
                        value: score.toString(),
                        gradient: AppColors.gradientScore,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        label: 'Streak',
                        value: '$streak days',
                        gradient: AppColors.gradientStreak,
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.emoji_events_rounded,
                        label: 'Level',
                        value: levelName,
                        gradient: AppColors.gradientLevel,
                        score: score,
                        nextLevelScore: LevelThresholds.getNextLevelScore(score),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ─── Daily Practice ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Practice',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24, 
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: GoogleFonts.outfit(color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TaskCard(
                    icon: Icons.touch_app_rounded,
                    title: 'Vedic Jap',
                    subtitle: 'Today\'s count: $dailyJapCount',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => context.push('/jap'),
                  ),
                  const SizedBox(height: 12),
                  _TaskCard(
                    icon: Icons.self_improvement_rounded,
                    title: 'Deep Meditation',
                    subtitle: 'Morning Zen • 10 mins',
                    color: const Color(0xFF10B981),
                    onTap: () => context.push('/meditation'),
                  ),
                  const SizedBox(height: 12),
                  _TaskCard(
                    icon: Icons.edit_note_rounded,
                    title: 'Soul Journal',
                    subtitle: 'Reflect on gratitude',
                    color: const Color(0xFFF59E0B),
                    onTap: () => context.push('/journal'),
                  ),
                  const SizedBox(height: 32),

                  // ─── Daily Challenges ─────────────────────────────────
                  Text(
                    'Daily Challenges',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24, 
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _CustomChallengesSection(user: user),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

// ─── Stat Card Widget ──────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;
  final int? score;
  final int? nextLevelScore;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
    this.score,
    this.nextLevelScore,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (gradient as LinearGradient).colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Task Card Widget ──────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _TaskCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}


class _CustomChallengesSection extends ConsumerStatefulWidget {
  final user;
  const _CustomChallengesSection({required this.user});

  @override
  ConsumerState<_CustomChallengesSection> createState() => _CustomChallengesSectionState();
}

class _CustomChallengesSectionState extends ConsumerState<_CustomChallengesSection> {
  final TextEditingController _challengeController = TextEditingController();

  void _addChallenge() async {
    final text = _challengeController.text.trim();
    if (text.isEmpty) return;

    final updatedGoals = List<String>.from(widget.user.goals)..add(text);
    
    try {
      await ref.read(firestoreServiceProvider).updateUserStats(
        widget.user.uid,
        goals: updatedGoals,
      );
      _challengeController.clear();
      ref.read(currentUserProvider.notifier).refreshUser();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Challenge added successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add challenge: $e')),
      );
    }
  }

  void _removeChallenge(String challenge) async {
    final updatedGoals = List<String>.from(widget.user.goals)..remove(challenge);
    try {
      await ref.read(firestoreServiceProvider).updateUserStats(
        widget.user.uid,
        goals: updatedGoals,
      );
      ref.read(currentUserProvider.notifier).refreshUser();
    } catch (e) {
      debugPrint('Failed to remove challenge: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out default goals
    final customChallenges = widget.user.goals.where((g) => !GoalOptions.all.contains(g)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Add new challenge input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _challengeController,
                  decoration: const InputDecoration(
                    hintText: 'Add a new challenging to do...',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _addChallenge(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_task_rounded, color: Theme.of(context).colorScheme.primary),
                onPressed: _addChallenge,
              ),
            ],
          ),
        ),
        
        if (customChallenges.isNotEmpty) ...[
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customChallenges.length,
            itemBuilder: (context, index) {
              final challenge = customChallenges[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
                ),
                child: ListTile(
                  leading: Icon(Icons.stars_rounded, color: AppColors.gold, size: 20),
                  title: Text(challenge, style: GoogleFonts.outfit(fontSize: 15)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                    onPressed: () => _removeChallenge(challenge),
                  ),
                ),
              );
            },
          ),
        ] else ...[
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(Icons.format_list_bulleted_add, size: 48, color: Colors.grey.withOpacity(0.3)),
                const SizedBox(height: 8),
                Text(
                  'No custom challenges yet.\nAdd one above to stay motivated!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

