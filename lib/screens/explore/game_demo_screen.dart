import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';
import '../../widgets/glass_card.dart';

class MantraMatchGame extends StatefulWidget {
  const MantraMatchGame({super.key});

  @override
  State<MantraMatchGame> createState() => _MantraMatchGameState();
}

class _MantraMatchGameState extends State<MantraMatchGame> {
  final List<String> _symbols = ['🔱', '🏹', '🐘', '🐒', '🕉️', '🕯️', '🔱', '🏹', '🐘', '🐒', '🕉️', '🕯️'];
  late List<bool> _isFlipped;
  late List<bool> _isMatched;
  int? _firstIndex;
  bool _isBusy = false;
  int _matches = 0;

  @override
  void initState() {
    super.initState();
    _symbols.shuffle();
    _isFlipped = List.generate(_symbols.length, (_) => false);
    _isMatched = List.generate(_symbols.length, (_) => false);
  }

  void _onCardTap(int index) {
    if (_isBusy || _isFlipped[index] || _isMatched[index]) return;

    setState(() {
      _isFlipped[index] = true;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
    } else {
      _isBusy = true;
      if (_symbols[_firstIndex!] == _symbols[index]) {
        // Match!
        setState(() {
          _isMatched[_firstIndex!] = true;
          _isMatched[index] = true;
          _matches++;
          _firstIndex = null;
          _isBusy = false;
        });
        if (_matches == _symbols.length ~/ 2) {
          _showWinDialog();
        }
      } else {
        // No match
        Timer(const Duration(seconds: 1), () {
          setState(() {
            _isFlipped[_firstIndex!] = false;
            _isFlipped[index] = false;
            _firstIndex = null;
            _isBusy = false;
          });
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Congratulations! 🎉', 
            style: GoogleFonts.playfairDisplay(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text('You matched all the sacred symbols. You earned 50 points!',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close game
            },
            child: Text('Awesome', style: GoogleFonts.outfit(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Mantra Match',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Find the matching sacred symbols', 
                style: GoogleFonts.outfit(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _symbols.length,
                itemBuilder: (context, index) {
                  final isVisible = _isFlipped[index] || _isMatched[index];
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: GlassCard(
                      padding: EdgeInsets.zero,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isVisible 
                              ? Text(_symbols[index], key: ValueKey(index), style: const TextStyle(fontSize: 40))
                              : const Icon(Icons.star_rounded, key: ValueKey(-1), size: 40, color: AppColors.gold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
