import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../models/scheduled_audio.dart';

class AudioSchedulerService extends StateNotifier<List<ScheduledAudio>> {
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioSchedulerService() : super([]) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    // Check every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkScheduledAudios();
    });
  }

  void _checkScheduledAudios() {
    if (state.isEmpty) return;

    final now = DateTime.now();
    final toPlay = <ScheduledAudio>[];
    final remaining = <ScheduledAudio>[];

    for (var audio in state) {
      if (now.isAfter(audio.scheduledTime) || now.isAtSameMomentAs(audio.scheduledTime)) {
        toPlay.add(audio);
      } else {
        remaining.add(audio);
      }
    }

    if (toPlay.isNotEmpty) {
      state = remaining;
      for (var audio in toPlay) {
        _playAlarmAudio(audio.url);
      }
    }
  }

  Future<void> _playAlarmAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      print('Scheduler Audio Error: $e');
    }
  }

  void scheduleAudio(ScheduledAudio audio) {
    state = [...state, audio];
  }

  void cancelScheduledAudio(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

final audioSchedulerProvider = StateNotifierProvider<AudioSchedulerService, List<ScheduledAudio>>((ref) {
  return AudioSchedulerService();
});
