import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/podcast.dart';
import '../widgets/audio_player_widget.dart';

class PodcastDetailScreen extends StatelessWidget {
  final Podcast podcast;

  PodcastDetailScreen({required this.podcast});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(podcast.trackName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: podcast.artworkUrl600,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              podcast.trackName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              podcast.artistName,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            AudioPlayerWidget(feedUrl: podcast.feedUrl),
          ],
        ),
      ),
    );
  }
}