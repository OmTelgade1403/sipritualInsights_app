import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../providers/app_providers.dart';

/// Explore screen with category-based content featuring spiritual resources.
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final userCategory = userAsync.value?.category ?? 'Adults';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Explore',
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover spiritual wisdom',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 24),
              _buildLibraryCard(context),
              const SizedBox(height: 24),
              _buildDeitySection(context),
              const SizedBox(height: 24),

              // Category content based on user type
              _buildCategoryContent(context, userCategory),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(BuildContext context, String category) {
    switch (category) {
      case 'Kids':
        return _buildKidsContent(context);
      case 'Teenagers':
        return _buildTeenContent(context);
      case 'Seniors':
        return _buildSeniorContent(context);
      default:
        return _buildAdultContent(context);
    }
  }

  Widget _buildLibraryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/books'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A11CB).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book_rounded, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sacred Library',
                    style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Read Hanuman Chalisa, Stotras & more',
                    style: GoogleFonts.outfit(
                        fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildDeitySection(BuildContext context) {
    final deities = [
      {'name': 'Ganesh', 'color': const Color(0xFFFF9933), 'icon': '🐘', 'desc': 'Remover of Obstacles'},
      {'name': 'Hanuman', 'color': const Color(0xFFFF4500), 'icon': '🐒', 'desc': 'The Mighty Devotee'},
      {'name': 'Shiv', 'color': const Color(0xFF00E5FF), 'icon': '🔱', 'desc': 'The Destroyer'},
      {'name': 'Ram', 'color': const Color(0xFFFFD700), 'icon': '🏹', 'desc': 'Lord of Virtue'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('🙏 Sacred Deities', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            TextButton(
              onPressed: () => context.push('/media'),
              child: Text('See All', style: GoogleFonts.outfit(color: AppColors.gold, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: deities.length,
            itemBuilder: (context, index) {
              final deity = deities[index];
              final color = deity['color'] as Color;
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: InkWell(
                  onTap: () => _showKrishnaStory(context),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(deity['icon'] as String, style: const TextStyle(fontSize: 32)),
                        const Spacer(),
                        Text(
                          deity['name'] as String,
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          deity['desc'] as String,
                          style: GoogleFonts.outfit(fontSize: 10, color: Colors.white60),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKidsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🌈 Kids Corner', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: [
            _buildInteractiveCard(
              context,
              'Animated Stories',
              'Bal Krishna LILA',
              '🎬',
              Colors.purple,
              () => _showKrishnaStory(context),
            ),
            _buildInteractiveCard(
              context,
              'Mantra Game',
              'Match & Learn',
              '🧩',
              Colors.orange,
              () => _showMantraMatch(context),
            ),
            _buildInteractiveCard(
              context,
              'Divine Coloring',
              'Paint the deities',
              '🎨',
              Colors.pink,
              () => {},
            ),
            _buildInteractiveCard(
              context,
              'Kid Bhajans',
              'Simple Tunes',
              '🎵',
              Colors.teal,
              () => context.push('/media'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveCard(BuildContext context, String title, String subtitle, String emoji, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.outfit(fontSize: 12, color: color.withValues(alpha: 0.8)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeenContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🧠 Stress Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _ContentCard(
          title: 'Breathing Exercises',
          subtitle: '4-7-8 technique for instant calm',
          icon: Icons.air_rounded,
          color: AppColors.accent,
          onTap: () {},
        ),
        _ContentCard(
          title: 'Exam Anxiety Relief',
          subtitle: 'Guided meditation for focus',
          icon: Icons.school_rounded,
          color: AppColors.primary,
          onTap: () => context.push('/meditation'),
        ),
        const SizedBox(height: 24),
        const Text('😊 Mood Tracker', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How are you feeling today?', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('😊', style: TextStyle(fontSize: 32)),
                  Text('😌', style: TextStyle(fontSize: 32)),
                  Text('😐', style: TextStyle(fontSize: 32)),
                  Text('😟', style: TextStyle(fontSize: 32)),
                  Text('😢', style: TextStyle(fontSize: 32)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdultContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🧘 Advanced Practice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _ContentCard(
          title: 'Vipassana Technique',
          subtitle: 'Deep insight meditation practice',
          icon: Icons.self_improvement_rounded,
          color: AppColors.primary,
          onTap: () {},
        ),
        _ContentCard(
          title: 'Chakra Balancing',
          subtitle: 'Align your energy centers',
          icon: Icons.brightness_7_rounded,
          color: const Color(0xFFE040FB),
          onTap: () => context.push('/meditation'),
        ),
        const SizedBox(height: 24),
        const Text('🤖 AI Spiritual Assistant', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/ai-chat'),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.gradientPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Spiritual Guide',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ask about meditation & peace',
                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white60, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeniorContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🎶 Devotional Songs', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _ContentCard(
          title: 'Morning Bhajans',
          subtitle: 'Start your day with devotion',
          icon: Icons.music_note_rounded,
          color: AppColors.secondary,
          onTap: () => context.push('/media'),
        ),
        _ContentCard(
          title: 'Evening Aarti',
          subtitle: 'Peaceful evening prayers',
          icon: Icons.nightlight_rounded,
          color: AppColors.primary,
          onTap: () => context.push('/media'),
        ),
      ],
    );
  }
  void _showKrishnaStory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF8E1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.brown.withOpacity(0.2), borderRadius: BorderRadius.circular(2))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Krishna & The Butter', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.brown.shade800)),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.orange.shade100,
                        child: const Center(child: Text('🎨 [Krishna Illustration]', style: TextStyle(fontSize: 18, color: Colors.orange))),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Once upon a time, in the beautiful village of Vrindavan, lived a playful little boy named Krishna. Krishna loved butter more than anything else in the world!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 18, height: 1.6, color: Colors.brown.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'His mother, Yashoda, would keep the fresh butter in pots high up from the ceiling. But little Krishna was very clever...',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 18, height: 1.6, color: Colors.brown.shade700),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Next Page ➔'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMantraMatch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1240),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Mantra Match 🧩', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Connect the word to its spiritual vibe!', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            _buildMatchRow('Om', 'Peace', Colors.blue),
            const SizedBox(height: 12),
            _buildMatchRow('Namaste', 'Respect', Colors.orange),
            const SizedBox(height: 12),
            _buildMatchRow('Shanti', 'Calm', Colors.green),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Maybe Later')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Play!')),
        ],
      ),
    );
  }

  Widget _buildMatchRow(String word, String vibe, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.5))),
          child: Text(word, style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold)),
        ),
        const Icon(Icons.link_rounded, color: Colors.white24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.5))),
          child: Text(vibe, style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// ─── Helper Widgets ─────────────────────────────────────────────────────────

class _ContentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ContentCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white30),
          ],
        ),
      ),
    );
  }
}

