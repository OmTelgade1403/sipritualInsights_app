import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class KidsGameScreen extends StatefulWidget {
  const KidsGameScreen({super.key});

  @override
  State<KidsGameScreen> createState() => _KidsGameScreenState();
}

class _KidsGameScreenState extends State<KidsGameScreen> {
  final List<Map<String, dynamic>> items = [
    {'name': 'Om', 'icon': '🕉️', 'color': Colors.orange},
    {'name': 'Lotus', 'icon': '🪷', 'color': Colors.pink},
    {'name': 'Shanti', 'icon': '🕊️', 'color': Colors.blue},
    {'name': 'Dharma', 'icon': '☸️', 'color': Colors.amber},
  ];

  Map<int, bool> matched = {};
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Mantra Match Game', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Match the symbols! ✨',
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap an icon to select it.',
              style: GoogleFonts.outfit(fontSize: 15, color: Colors.white60),
            ),
            const SizedBox(height: 48),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isMatched = matched.containsKey(index);
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      if (isMatched) return;
                      setState(() {
                        if (selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                          // In a real match game there'd be logic here, 
                          // but for demo we just "match" it after a delay
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (mounted) {
                              setState(() {
                                matched[index] = true;
                                selectedIndex = null;
                              });
                              if (matched.length == items.length) {
                                _showWinDialog();
                              }
                            }
                          });
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isMatched 
                          ? Colors.green.withValues(alpha: 0.2) 
                          : isSelected 
                            ? (item['color'] as Color).withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: isMatched 
                            ? Colors.green 
                            : isSelected 
                              ? (item['color'] as Color)
                              : Colors.white10,
                          width: 2,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(color: (item['color'] as Color).withValues(alpha: 0.2), blurRadius: 15)
                        ] : [],
                      ),
                      child: Center(
                        child: Text(
                          item['icon'] as String,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (matched.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => matched = {}),
                child: const Text('Reset Game'),
              ),
          ],
        ),
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1240),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        title: const Text('You Won! 🎉', style: TextStyle(color: Colors.white)),
        content: const Text('You matched all the spiritual symbols! Great work!', style: TextStyle(color: Colors.white70)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => matched = {});
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
