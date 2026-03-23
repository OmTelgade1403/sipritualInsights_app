import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../models/activity_model.dart';
import '../../providers/app_providers.dart';

/// Jap Counter screen with tap-based counter, progress ring, and mantra selection.
class JapCounterScreen extends ConsumerStatefulWidget {
  const JapCounterScreen({super.key});

  @override
  ConsumerState<JapCounterScreen> createState() => _JapCounterScreenState();
}

class _JapCounterScreenState extends ConsumerState<JapCounterScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _goal = 108;
  final TextEditingController _mantraController = TextEditingController(text: 'Om');
  final TextEditingController _countController = TextEditingController(text: '0');
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Initialize count from user model if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).value;
      if (user != null && user.japCount > 0) {
        setState(() {
          _count = user.japCount;
          _countController.text = _count.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mantraController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _incrementCount() {
    if (_count >= _goal) return;
    HapticFeedback.lightImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    setState(() {
      _count++;
      _countController.text = _count.toString();
    });

    if (_count == _goal) {
      _onGoalReached();
    }
  }

  void _onGoalReached() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('🎉 Congratulations!'),
        content: Text(
          'You completed $_goal Jap of "${_mantraController.text}"!\n+$_count points earned!',
          style: GoogleFonts.outfit(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _saveAndExit();
            },
            child: const Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _count = 0;
                _countController.text = '0';
              });
            },
            child: const Text('Start Again'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndExit() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final activity = ActivityModel(
      id: const Uuid().v4(),
      type: 'jap',
      count: _count,
      mantra: _mantraController.text,
      pointsEarned: _count,
    );

    try {
      await ref.read(firestoreServiceProvider).saveActivity(user.uid, activity);
      
      // Update overall japCount and progress
      final updatedJapCount = user.japCount + _count;
      final progress = (updatedJapCount / 1000.0).clamp(0.0, 1.0); // Demo progress metric
      
      await ref.read(firestoreServiceProvider).updateUserStats(
        user.uid, 
        japCount: updatedJapCount,
        progress: progress,
        score: user.score + _count,
      );
      
      await ref.read(currentUserProvider.notifier).refreshUser();
      ref.invalidate(todayActivitiesProvider);
    } catch (_) {}

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_count / _goal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Sacred Jap Counter', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check_circle_rounded : Icons.edit_note_rounded),
            onPressed: () => setState(() => _isEditing = !_isEditing),
            tooltip: 'Edit Mantra/Count',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Custom Mantra/Text Editor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _mantraController,
                  enabled: _isEditing,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Mantra...',
                    border: _isEditing ? null : InputBorder.none,
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondary.withOpacity(0.3))),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Goal selector (Hidden when editing count manually)
              if (!_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Goal: ', style: GoogleFonts.outfit(fontSize: 14, color: Colors.white60)),
                    ...([21, 54, 108, 216]).map((g) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('$g'),
                        selected: _goal == g,
                        onSelected: (_) => setState(() {
                          _goal = g;
                        }),
                        selectedColor: AppColors.secondary,
                        labelStyle: GoogleFonts.outfit(
                          color: _goal == g ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                  ],
                ),
              
              const SizedBox(height: 32),

              // Progress ring and counter
              Center(
                child: GestureDetector(
                  onTap: _isEditing ? null : _incrementCount,
                  child: ScaleTransition(
                    scale: _pulseAnimation,
                    child: SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withOpacity(0.15),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          // Progress ring
                          SizedBox(
                            width: 280,
                            height: 280,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 14,
                              strokeCap: StrokeCap.round,
                              valueColor: AlwaysStoppedAnimation(AppColors.secondary),
                              backgroundColor: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          // Counter Text / Editor
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isEditing)
                                SizedBox(
                                  width: 120,
                                  child: TextField(
                                    controller: _countController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    onChanged: (v) {
                                      final n = int.tryParse(v);
                                      if (n != null) setState(() => _count = n);
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  '$_count',
                                  style: GoogleFonts.outfit(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              Text(
                                _isEditing ? 'EDIT COUNT' : 'OF $_goal',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary.withOpacity(0.8),
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Instructions
              if (!_isEditing)
                Text(
                  'TAP TO CHANT',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Colors.white24,
                  ),
                ),

              const SizedBox(height: 60),

              // Bottom actions
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() {
                          _count = 0;
                          _countController.text = '0';
                        }),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white10),
                          foregroundColor: Colors.white60,
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _count > 0 ? _saveAndExit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.black,
                        ),
                        icon: const Icon(Icons.check_rounded),
                        label: const Text('Save Progress'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
