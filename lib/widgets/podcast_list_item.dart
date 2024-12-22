import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/podcast.dart';
import '../screens/podcast_detail_screen.dart';

class PodcastListItem extends StatelessWidget {
  final Podcast podcast;

  PodcastListItem({required this.podcast});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => ListTile(
        leading: CachedNetworkImage(
          imageUrl: podcast.artworkUrl600,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(podcast.trackName),
        subtitle: Text(podcast.artistName),
        onTap: () {
          Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (_) => PodcastDetailScreen(podcast: podcast),
            ),
          );
        },
      ),
      cupertino: (_, __) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (_) => PodcastDetailScreen(podcast: podcast),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: podcast.artworkUrl600,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      podcast.trackName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      podcast.artistName,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
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