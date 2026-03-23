import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/activity_model.dart';
import '../../providers/app_providers.dart';

/// Meditation timer screen with duration selection, countdown, and ambient visuals.
class MeditationScreen extends ConsumerStatefulWidget {
  const MeditationScreen({super.key});

  @override
  ConsumerState<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends ConsumerState<MeditationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMinutes = 5;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isCompleted = false;
  Timer? _timer;
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

  final List<int> _durations = [5, 10, 15, 20, 30];

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _selectedMinutes * 60;
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breatheAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breatheController.dispose();
    super.dispose();
  }

  void _startMeditation() {
    setState(() => _isRunning = true);
    _breatheController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _completeMeditation();
      }
    });
  }

  void _pauseMeditation() {
    _timer?.cancel();
    _breatheController.stop();
    setState(() => _isRunning = false);
  }

  void _completeMeditation() {
    _timer?.cancel();
    _breatheController.stop();
    HapticFeedback.heavyImpact();
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
    _saveSession();
  }

  Future<void> _saveSession() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final actualMinutes = _selectedMinutes - (_remainingSeconds ~/ 60);
    final activity = ActivityModel(
      id: const Uuid().v4(),
      type: 'meditation',
      durationMinutes: actualMinutes > 0 ? actualMinutes : _selectedMinutes,
      pointsEarned: PointValues.meditation,
    );

    try {
      await ref.read(firestoreServiceProvider).saveActivity(user.uid, activity);
      await ref.read(gamificationServiceProvider).awardPoints(user, 'meditation');
      await ref.read(currentUserProvider.notifier).refreshUser();
    } catch (_) {}
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _isCompleted
        ? 1.0
        : 1.0 - (_remainingSeconds / (_selectedMinutes * 60));

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0A0618)
          : const Color(0xFFF0EBF8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Meditation', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (!_isRunning && !_isCompleted) ...[
              const SizedBox(height: 24),
              Text(
                'Choose Duration',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              // Duration chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _durations.map((d) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text('$d min'),
                    selected: _selectedMinutes == d,
                    onSelected: (_) => setState(() {
                      _selectedMinutes = d;
                      _remainingSeconds = d * 60;
                    }),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: GoogleFonts.outfit(
                      color: _selectedMinutes == d ? Colors.white : null,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],

            // Main circle
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _breatheAnimation,
                  builder: (context, child) {
                    final scale = _isRunning ? _breatheAnimation.value : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow
                            if (_isRunning)
                              Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withValues(alpha: 0.2),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            // Progress ring
                            SizedBox(
                              width: 260,
                              height: 260,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 8,
                                strokeCap: StrokeCap.round,
                                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                              ),
                            ),
                            // Inner circle
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.accent.withValues(alpha: 0.08),
                                    AppColors.primary.withValues(alpha: 0.08),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isCompleted) ...[
                                    const Icon(Icons.check_circle, size: 48, color: AppColors.accent),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Well Done!',
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                    Text(
                                      '+${PointValues.meditation} pts',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ] else ...[
                                    if (_isRunning)
                                      Text(
                                        'Breathe',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: AppColors.accent.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatTime(_remainingSeconds),
                                      style: GoogleFonts.outfit(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.accent,
                                        letterSpacing: 4,
                                      ),
                                    ),
                                    if (!_isRunning)
                                      Text(
                                        'minutes',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(24),
              child: _isCompleted
                  ? ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text('Return Home', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600)),
                    )
                  : Row(
                      children: [
                        if (_isRunning) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _pauseMeditation,
                              child: const Text('Pause'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _completeMeditation,
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                              child: const Text('End Session'),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _startMeditation,
                              icon: const Icon(Icons.play_arrow_rounded, size: 28),
                              label: Text(
                                _remainingSeconds < _selectedMinutes * 60 ? 'Resume' : 'Begin',
                                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                minimumSize: const Size(double.infinity, 56),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
