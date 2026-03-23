import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../widgets/glass_card.dart';

class StoryReaderScreen extends StatefulWidget {
  final String title;
  const StoryReaderScreen({super.key, required this.title});

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  int _currentPage = 0;
  final List<Map<String, String>> _pages = [
    {
      'image': '🐘',
      'text': 'Once upon a time, in a lush forest, there lived a wise elephant named Gaja...'
    },
    {
      'image': '🌳',
      'text': 'Gaja was known for his extreme patience and kindness towards all creatures.'
    },
    {
      'image': '☀️',
      'text': 'One day, a small squirrel asked Gaja, "How do you stay so calm even when things go wrong?"'
    },
    {
      'image': '✨',
      'text': 'Gaja smiled and said, "Inner peace comes when we understand that everything happens for a reason."'
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.title,
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: GlassCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(page['image']!, style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 40),
                    Text(
                      page['text']!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${_currentPage + 1} of ${_pages.length}',
                  style: GoogleFonts.outfit(color: Colors.white70),
                ),
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_currentPage == _pages.length - 1 ? 'Finish' : 'Next'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
