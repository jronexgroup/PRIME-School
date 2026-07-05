import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_colors.dart';

class YoutubeEmbedWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubeEmbedWidget({super.key, required this.videoUrl});

  @override
  State<YoutubeEmbedWidget> createState() => _YoutubeEmbedWidgetState();
}

class _YoutubeEmbedWidgetState extends State<YoutubeEmbedWidget> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView(widget.videoUrl);
  }

  @override
  void didUpdateWidget(YoutubeEmbedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      setState(() => _isLoading = true);
      _initWebView(widget.videoUrl);
    }
  }

  void _initWebView(String videoUrl) {
    final videoId = _extractVideoId(videoUrl);
    final startSeconds = _extractTimestamp(videoUrl);

    final embedUrl = 'https://www.youtube.com/embed/$videoId'
        '?autoplay=1'
        '&start=$startSeconds'
        '&rel=0'
        '&modestbranding=1'
        '&playsinline=1'
        '&controls=1';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => _isLoading = true,
        onPageFinished: (_) {
          if (mounted) setState(() => _isLoading = false);
        },
        onWebResourceError: (error) {
          debugPrint('YouTube WebResourceError: ${error.description} code=${error.errorCode}');
        },
      ))
      ..loadRequest(Uri.parse(embedUrl));
  }

  String _extractVideoId(String url) {
    final patterns = [
      RegExp(r'(?:youtube\.com/watch\?v=|youtu\.be/)([a-zA-Z0-9_-]{11})'),
    ];
    for (final p in patterns) {
      final match = p.firstMatch(url);
      if (match != null) return match.group(1)!;
    }
    debugPrint('YouTube: Could not extract video ID from $url, using fallback');
    return 'UrsmFxEIp5k';
  }

  int _extractTimestamp(String url) {
    final match = RegExp(r'[?&]t=(\d+)').firstMatch(url);
    final ts = match != null ? int.parse(match.group(1)!) : 0;
    debugPrint('YouTube: Extracted timestamp $ts from $url');
    return ts;
  }

  void _openFullscreen() {
    final videoId = _extractVideoId(widget.videoUrl);
    final startSeconds = _extractTimestamp(widget.videoUrl);
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _FullscreenVideoPlayer(videoId: videoId, startSeconds: startSeconds),
    ));
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
    final videoId = _extractVideoId(widget.videoUrl);
    final startSeconds = _extractTimestamp(widget.videoUrl);

    if (useApp) {
      final appUri = Uri.parse('youtube://watch?v=$videoId${startSeconds > 0 ? '&t=${startSeconds}s' : ''}');
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    final webUri = Uri.parse('https://youtu.be/$videoId${startSeconds > 0 ? '?t=$startSeconds' : ''}');
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                if (_controller != null)
                  WebViewWidget(controller: _controller!),
                if (_isLoading)
                  Container(
                    color: Colors.black87,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
              ],
            ),
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
            const SizedBox(width: 4),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
              ),
              child: IconButton(
                icon: const Icon(Icons.fullscreen_rounded, size: 18),
                tooltip: 'Full Screen',
                color: isDark ? Colors.white70 : Colors.black54,
                onPressed: _openFullscreen,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FullscreenVideoPlayer extends StatelessWidget {
  final String videoId;
  final int startSeconds;

  const _FullscreenVideoPlayer({required this.videoId, required this.startSeconds});

  @override
  Widget build(BuildContext context) {
    final embedUrl = 'https://www.youtube.com/embed/$videoId'
        '?autoplay=1'
        '&start=$startSeconds'
        '&rel=0'
        '&modestbranding=1'
        '&playsinline=1'
        '&controls=1';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Now Playing', style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(embedUrl)),
          ),
        ),
      ),
    );
  }
}
