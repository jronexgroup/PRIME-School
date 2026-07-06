import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/constants/app_colors.dart';

class YoutubeEmbedWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubeEmbedWidget({super.key, required this.videoUrl});

  @override
  State<YoutubeEmbedWidget> createState() => _YoutubeEmbedWidgetState();
}

class _YoutubeEmbedWidgetState extends State<YoutubeEmbedWidget> {
  YoutubePlayerController? _controller;
  String? _videoId;
  int _startSeconds = 0;
  int _currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _initPlayer(widget.videoUrl);
  }

  @override
  void didUpdateWidget(YoutubeEmbedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller?.close();
      _initPlayer(widget.videoUrl);
    }
  }

  void _initPlayer(String videoUrl) {
    _videoId = _extractVideoId(videoUrl);
    _startSeconds = _extractTimestamp(videoUrl);
    if (_videoId == null) return;

    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoId!,
      autoPlay: true,
      startSeconds: _startSeconds > 0 ? _startSeconds.toDouble() : null,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        strictRelatedVideos: true,
      ),
    );

    _controller!.videoStateStream.listen((state) {
      _currentPosition = state.position.inSeconds;
    });
  }

  String? _extractVideoId(String url) {
    final patterns = [
      RegExp(r'(?:youtube\.com/watch\?v=|youtu\.be/)([a-zA-Z0-9_-]{11})'),
    ];
    for (final p in patterns) {
      final match = p.firstMatch(url);
      if (match != null) return match.group(1)!;
    }
    debugPrint('YouTube: Could not extract video ID from $url');
    return null;
  }

  int _extractTimestamp(String url) {
    final match = RegExp(r'[?&]t=(\d+)').firstMatch(url);
    final ts = match != null ? int.parse(match.group(1)!) : 0;
    debugPrint('YouTube: Extracted timestamp $ts from $url');
    return ts;
  }

  void _showWatchOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_circle_fill, color: Colors.red),
              title: const Text('Open in YouTube App'),
              onTap: () {
                Navigator.pop(ctx);
                _launchYouTube(useApp: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_browser, color: Colors.blue),
              title: const Text('Open in Browser'),
              onTap: () {
                Navigator.pop(ctx);
                _launchYouTube(useApp: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchYouTube({bool useApp = true}) async {
    if (_videoId == null) return;
    final pos = _currentPosition > 0 ? _currentPosition : _startSeconds;

    if (useApp) {
      final appUri = Uri.parse('youtube://watch?v=$_videoId${pos > 0 ? '&t=${pos}s' : ''}');
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    final webUri = Uri.parse('https://youtu.be/$_videoId${pos > 0 ? '?t=$pos' : ''}');
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_controller == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(child: Text('Could not load video')),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: YoutubePlayer(
            controller: _controller!,
            aspectRatio: 16 / 9,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
              ),
              child: IconButton(
                icon: const Icon(Icons.play_circle_outline, size: 18),
                tooltip: 'Watch on YouTube',
                color: isDark ? Colors.white70 : Colors.black54,
                onPressed: _showWatchOptions,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
