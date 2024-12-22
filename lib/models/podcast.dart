class Podcast {
  final String trackName;
  final String artistName;
  final String artworkUrl600;
  final String feedUrl;

  Podcast({
    required this.trackName,
    required this.artistName,
    required this.artworkUrl600,
    required this.feedUrl,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      trackName: json['trackName'] ?? '',
      artistName: json['artistName'] ?? '',
      artworkUrl600: json['artworkUrl600'] ?? '',
      feedUrl: json['feedUrl'] ?? '',
    );
  }
}