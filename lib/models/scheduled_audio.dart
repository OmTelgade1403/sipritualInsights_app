class ScheduledAudio {
  final String id;
  final String url;
  final String title;
  final String subtitle;
  final String image;
  final DateTime scheduledTime;

  ScheduledAudio({
    required this.id,
    required this.url,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.scheduledTime,
  });
}
