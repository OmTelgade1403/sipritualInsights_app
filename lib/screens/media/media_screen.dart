import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/theme.dart';
import '../../models/scheduled_audio.dart';
import '../../services/audio_scheduler_service.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  late AudioPlayer _audioPlayer;
  YoutubePlayerController? _ytController;
  String? _currentlyPlayingTitle;
  bool _isAudioPlaying = false;

  final List<Map<String, String>> _audioItems = [
    {
      'title': 'Hanuman Chalisa',
      'artist': 'Gulshan Kumar',
      'duration': '9:40',
      'url': 'https://archive.org/download/HanumanChalisa_201611/Hanuman%20Chalisa.mp3',
      'image': 'https://images.unsplash.com/photo-1605722243979-fe0be8158232?w=500&auto=format'
    },
    {
      'title': 'Deep Meditation',
      'artist': 'Spiritual Mind',
      'duration': '15:00',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'image': 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=500&auto=format'
    },
    {
      'title': 'Zen Flute',
      'artist': 'Peaceful Soul',
      'duration': '20:00',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'image': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=500&auto=format'
    },
    {
      'title': 'Morning Mantra',
      'artist': 'Vedic Chants',
      'duration': '08:45',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'image': 'https://images.unsplash.com/photo-1528715471579-d1bcf0ba5e83?w=500&auto=format'
    },
  ];

  final List<Map<String, String>> _videoItems = [
    {'title': 'Hanuman Chalisa - T-Series', 'artist': 'Gulshan Kumar', 'id': 'AETFvQonfV8'},
    {'title': 'Shiva Tandava Stotram', 'artist': 'Sacred Chants', 'id': 'mG71hSrx4hU'},
    {'title': 'Sadhguru on Meditation', 'artist': 'Sadhguru', 'id': 'Tf09kNoK0Kk'},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioSession();
    
    // Listen for audio player state changes
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isAudioPlaying = state.playing;
        });
      }
    });
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _ytController?.dispose();
    super.dispose();
  }

  Future<void> _scheduleAudio(Map<String, String> audio) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final scheduledTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    
    if (scheduledTime.isBefore(DateTime.now())) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot schedule in the past!')),
      );
      return;
    }

    final scheduledAudio = ScheduledAudio(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: audio['url']!,
      title: audio['title']!,
      subtitle: audio['artist']!,
      image: audio['image']!,
      scheduledTime: scheduledTime,
    );

    ref.read(audioSchedulerProvider.notifier).scheduleAudio(scheduledAudio);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scheduled "${audio['title']}" at ${DateFormat.jm().format(scheduledTime)}')),
    );
  }

  Future<void> _playAudio(String url, String title) async {
    try {
      if (_currentlyPlayingTitle == title && _isAudioPlaying) {
        await _audioPlayer.pause();
      } else if (_currentlyPlayingTitle == title && !_isAudioPlaying) {
        await _audioPlayer.play();
      } else {
        await _audioPlayer.setUrl(url);
        _currentlyPlayingTitle = title;
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void _playVideo(String videoId) {
    if (_ytController != null) {
      _ytController!.load(videoId);
    } else {
      setState(() {
        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      });
    }
    // Stop audio if playing
    if (_isAudioPlaying) {
      _audioPlayer.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.8),
              const Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text('Sacred Media',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            bottom: TabBar(
              labelColor: AppColors.gold,
              unselectedLabelColor: Colors.white38,
              labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
              indicatorColor: AppColors.gold,
              indicatorWeight: 3,
              dividerColor: Colors.white10,
              tabs: const [
                Tab(text: 'Audio Chants'),
                Tab(text: 'Divine Videos'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildAudioSection(),
              _buildVideoSection(),
            ],
          ),
          bottomNavigationBar: _currentlyPlayingTitle != null ? _buildMiniPlayer() : null,
        ),
      ),
    );
  }

  Widget _buildAudioSection() {
    final scheduledAudios = ref.watch(audioSchedulerProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      children: [
        if (scheduledAudios.isNotEmpty) ...[
          Text('Scheduled Playback ⏰', style: GoogleFonts.outfit(fontSize: 18, color: AppColors.gold, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...scheduledAudios.map((sa) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.schedule, color: AppColors.gold),
                  title: Text(sa.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('MMM d, h:mm a').format(sa.scheduledTime), style: const TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.white54),
                    onPressed: () => ref.read(audioSchedulerProvider.notifier).cancelScheduledAudio(sa.id),
                  ),
                ),
              )),
          const SizedBox(height: 24),
          Text('Available Tracks', style: GoogleFonts.outfit(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
        ],
        ..._audioItems.map((audio) {
          final isPlaying = _currentlyPlayingTitle == audio['title'] && _isAudioPlaying;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isPlaying ? AppColors.gold.withOpacity(0.3) : Colors.white10,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      audio['image']!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.white10,
                          child: const Icon(Icons.music_note_rounded, color: Colors.white54),
                        );
                      },
                    ),
                    if (isPlaying)
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.black45,
                        child: const _PlayingWave(),
                      ),
                  ],
                ),
              ),
              title: Text(
                audio['title']!,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPlaying ? AppColors.gold : Colors.white,
                ),
              ),
              subtitle: Text(
                audio['artist']!,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.alarm_add_rounded, color: Colors.white54, size: 24),
                    onPressed: () => _scheduleAudio(audio),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                      color: isPlaying ? AppColors.gold : AppColors.accent,
                      size: 36,
                    ),
                    onPressed: () => _playAudio(audio['url']!, audio['title']!),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Column(
      children: [
        if (_ytController != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: _ytController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppColors.gold,
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _videoItems.length,
            itemBuilder: (context, index) {
              final video = _videoItems[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.play_lesson_rounded, color: AppColors.gold),
                  title: Text(
                    video['title']!,
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  subtitle: Text(video['artist']!, style: GoogleFonts.outfit(fontSize: 12, color: Colors.white38)),
                  onTap: () => _playVideo(video['id']!),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.music_note_rounded, color: AppColors.gold),
        title: Text(
          _currentlyPlayingTitle ?? '',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            _isAudioPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            if (_isAudioPlaying) {
              _audioPlayer.pause();
            } else {
              _audioPlayer.play();
            }
          },
        ),
      ),
    );
  }
}

class _PlayingWave extends StatelessWidget {
  const _PlayingWave();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      color: Colors.black45,
      child: const Center(
        child: Icon(Icons.graphic_eq_rounded, color: AppColors.gold, size: 32),
      ),
    );
  }
}
