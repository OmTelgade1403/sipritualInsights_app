import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

class VipassanaScreen extends StatelessWidget {
  const VipassanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Vipassana Meditation', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B1E54), Color(0xFF1A1230)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill_rounded, size: 60, color: AppColors.gold),
              ),
            ),
            const SizedBox(height: 32),
            Text('What is Vipassana?', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
              'Vipassana, which means to see things as they really are, is one of India\'s most ancient techniques of meditation. It was taught in India more than 2,500 years ago as a universal remedy for universal ills.',
              style: GoogleFonts.outfit(fontSize: 16, color: Colors.white70, height: 1.6),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Guided Session',
              'A 10-minute introduction to Anapana (breath awareness) to prepare for Vipassana.',
              Icons.format_quote_rounded,
            ),
            const SizedBox(height: 16),
            _buildSection(
              'The Technique',
              'Observe the sensations throughout the body with equanimity, understanding their impermanent nature.',
              Icons.self_improvement_rounded,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Start Demo Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String desc, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.gold, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(desc, style: GoogleFonts.outfit(fontSize: 14, color: Colors.white60)),
            ],
          ),
        ),
      ],
    );
  }
}
