import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String feedUrl;

  AudioPlayerWidget({required this.feedUrl});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAudioUrl();
  }

  Future<void> _fetchAudioUrl() async {
    try {
      final response = await http.get(Uri.parse(widget.feedUrl));
      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.body);
        final item = document.findAllElements('item').first;
        final enclosure = item.findElements('enclosure').first;
        setState(() {
          _audioUrl = enclosure.getAttribute('url');
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching audio URL: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playPause() async {
    if (_audioPlayer.playerState.processingState == ProcessingState.idle) {
      if (_audioUrl != null) {
        await _audioPlayer.setUrl(_audioUrl!);
        _audioPlayer.play();
      }
    } else if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  if (_isLoading) {
    return PlatformCircularProgressIndicator();
  }

  if (_audioUrl == null) {
    return Text('No audio available.');
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      StreamBuilder<PositionData>(
        stream: Rx.combineLatest2<Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.durationStream,
          (position, duration) => PositionData(position, duration ?? Duration.zero),
        ),
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          return SeekBar(
            position: positionData?.position ?? Duration.zero,
            duration: positionData?.duration ?? Duration.zero,
            onChangeEnd: (newPosition) {
              _audioPlayer.seek(newPosition);
            },
          );
        },
      ),
      StreamBuilder<PlayerState>(
        stream: _audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final isPlaying = playerState?.playing ?? false;

          return PlatformIconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 48,
            ),
            onPressed: _playPause,
          );
        },
      ),
    ],
  );
  }
}

// PositionDataクラスの定義
class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}

// SeekBarウィジェットの実装
class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.position,
    required this.duration,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _sliderValue;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    double maxValue = widget.duration.inMilliseconds.toDouble();
    double value = (_isDragging
        ? _sliderValue!
        : widget.position.inMilliseconds.clamp(0, maxValue).toDouble())/maxValue;

    return Column(
      children: [
        PlatformSlider(
          min: 0,
          max: 1.0,
          value: value > 0 ? value : 0,
          onChangeStart: (val) {
            setState(() {
              _isDragging = true;
            });
          },
          onChanged: (val) {
            setState(() {
              _sliderValue = val;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(Duration(milliseconds: val.toInt()));
            }
          },
          onChangeEnd: (val) {
            setState(() {
              _isDragging = false;
            });
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(Duration(milliseconds: val.toInt()));
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(widget.position)),
              Text(_formatDuration(widget.duration)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoMin = twoDigits(duration.inMinutes.remainder(60));
    final twoSec = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoMin:$twoSec';
  }
}