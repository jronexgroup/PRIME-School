import 'package:flutter/material.dart';
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
      _isLoading = true;
      _initWebView(widget.videoUrl);
    }
  }

  void _initWebView(String videoUrl) {
    final videoId = _extractVideoId(videoUrl);
    final startSeconds = _extractTimestamp(videoUrl);
    final autoplay = startSeconds > 0 ? 1 : 1;

    final html = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #000; display: flex; justify-content: center; align-items: center; height: 100vh; overflow: hidden; }
.container { width: 100%; max-width: 100%; position: relative; padding-bottom: 56.25%; height: 0; }
.container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
</style>
</head>
<body>
<div class="container">
<iframe src="https://www.youtube.com/embed/$videoId?autoplay=$autoplay&start=$startSeconds&rel=0&modestbranding=1&playsinline=1"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen>
</iframe>
</div>
</body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => _isLoading = true,
        onPageFinished: (_) {
          if (mounted) setState(() => _isLoading = false);
        },
      ))
      ..loadHtmlString(html);
  }

  String _extractVideoId(String url) {
    final patterns = [
      RegExp(r'(?:youtube\.com/watch\?v=|youtu\.be/)([a-zA-Z0-9_-]{11})'),
    ];
    for (final p in patterns) {
      final match = p.firstMatch(url);
      if (match != null) return match.group(1)!;
    }
    return 'UrsmFxEIp5k';
  }

  int _extractTimestamp(String url) {
    final match = RegExp(r'[?&]t=(\d+)').firstMatch(url);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  void _openFullscreen() {
    final videoId = _extractVideoId(widget.videoUrl);
    final startSeconds = _extractTimestamp(widget.videoUrl);
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _FullscreenVideoPlayer(videoId: videoId, startSeconds: startSeconds),
    ));
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
    final html = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #000; display: flex; justify-content: center; align-items: center; height: 100vh; overflow: hidden; }
.container { width: 100%; max-width: 100%; position: relative; padding-bottom: 56.25%; height: 0; }
.container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
</style>
<script>
function toggleFullscreen() {
  var iframe = document.querySelector('iframe');
  if (iframe.requestFullscreen) iframe.requestFullscreen();
  else if (iframe.webkitRequestFullscreen) iframe.webkitRequestFullscreen();
}
</script>
</head>
<body>
<div class="container">
<iframe id="player" src="https://www.youtube.com/embed/$videoId?autoplay=1&start=$startSeconds&rel=0&modestbranding=1"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen>
</iframe>
</div>
</body>
</html>
''';

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
              ..loadHtmlString(html),
          ),
        ),
      ),
    );
  }
}
