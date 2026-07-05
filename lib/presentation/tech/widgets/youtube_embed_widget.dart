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

    final html = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #000; display: flex; justify-content: center; align-items: center; height: 100vh; overflow: hidden; }
#player-container { width: 100%; max-width: 100%; position: relative; padding-bottom: 56.25%; height: 0; }
#player-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
</style>
</head>
<body>
<div id="player-container">
  <div id="player"></div>
</div>
<script>
var tag = document.createElement('script');
tag.src = 'https://www.youtube.com/iframe_api';
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    height: '100%',
    width: '100%',
    videoId: '$videoId',
    playerVars: {
      'autoplay': 1,
      'start': $startSeconds,
      'rel': 0,
      'modestbranding': 1,
      'playsinline': 1,
      'origin': 'https://flutter.dev',
      'enablejsapi': 1,
      'controls': 1
    },
    events: {
      'onReady': onPlayerReady,
      'onStateChange': onPlayerStateChange,
      'onError': onPlayerError
    }
  });
}

function onPlayerReady(event) {
  if ($startSeconds > 0) {
    player.seekTo($startSeconds, true);
  }
  player.playVideo();
  YTSeeked = true;
  PlayerReady.postMessage('ready');
}

var YTSeeked = false;
function onPlayerStateChange(event) {
  if (event.data == YT.PlayerState.PLAYING && !YTSeeked && $startSeconds > 0) {
    player.seekTo($startSeconds, true);
    YTSeeked = true;
  }
}

function onPlayerError(event) {
  PlayerError.postMessage(event.data.toString());
}

function getCurrentTime() {
  if (player && player.getCurrentTime) {
    return player.getCurrentTime().toString();
  }
  return '0';
}

function seekTo(seconds) {
  if (player && player.seekTo) {
    player.seekTo(seconds, true);
  }
}

function togglePlay() {
  if (player) {
    if (player.getPlayerState() == YT.PlayerState.PLAYING) {
      player.pauseVideo();
    } else {
      player.playVideo();
    }
  }
}
</script>
</body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('PlayerReady', onMessageReceived: (_) {})
      ..addJavaScriptChannel('PlayerError', onMessageReceived: (msg) {
        debugPrint('YouTube Player Error: ${msg.message}');
      })
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => _isLoading = true,
        onPageFinished: (_) {
          if (mounted) setState(() => _isLoading = false);
        },
      ))
      ..loadHtmlString(html);
  }

  Future<double> _getCurrentTime() async {
    if (_controller == null) return 0;
    try {
      final result = await _controller!.runJavaScriptReturningResult('getCurrentTime()');
      return double.tryParse(result.toString()) ?? 0;
    } catch (_) {
      return 0;
    }
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

  Future<void> _openFullscreen() async {
    final videoId = _extractVideoId(widget.videoUrl);
    final currentTime = await _getCurrentTime();
    if (!mounted) return;
    final returnTime = await Navigator.push<double>(context, MaterialPageRoute(
      builder: (_) => _FullscreenVideoPlayer(videoId: videoId, startSeconds: currentTime.round()),
    ));
    if (returnTime != null && returnTime > 0 && mounted) {
      await _controller?.runJavaScriptReturningResult('seekTo($returnTime)');
    }
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

class _FullscreenVideoPlayer extends StatefulWidget {
  final String videoId;
  final int startSeconds;

  const _FullscreenVideoPlayer({required this.videoId, required this.startSeconds});

  @override
  State<_FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<_FullscreenVideoPlayer> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    final html = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { background: #000; display: flex; justify-content: center; align-items: center; height: 100vh; overflow: hidden; }
#player-container { width: 100%; max-width: 100%; position: relative; padding-bottom: 56.25%; height: 0; }
#player-container iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; }
</style>
</head>
<body>
<div id="player-container">
  <div id="player"></div>
</div>
<script>
var tag = document.createElement('script');
tag.src = 'https://www.youtube.com/iframe_api';
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    height: '100%',
    width: '100%',
    videoId: '${widget.videoId}',
    playerVars: {
      'autoplay': 1,
      'start': ${widget.startSeconds},
      'rel': 0,
      'modestbranding': 1,
      'playsinline': 1,
      'origin': 'https://flutter.dev',
      'enablejsapi': 1,
      'controls': 1
    },
    events: {
      'onReady': function(e) {
        if (${widget.startSeconds} > 0) {
          e.target.seekTo(${widget.startSeconds}, true);
        }
        e.target.playVideo();
      }
    }
  });
}
</script>
</body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(html);
  }

  double _currentTime = 0;

  Future<void> _captureAndPop() async {
    try {
      final result = await _controller.runJavaScriptReturningResult(
        '(function(){ if(window.player && window.player.getCurrentTime) return window.player.getCurrentTime().toString(); return "0"; })()',
      );
      _currentTime = double.tryParse(result.toString()) ?? 0;
    } catch (_) {}
    if (mounted) Navigator.pop(context, _currentTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: _captureAndPop,
        ),
        title: const Text('Now Playing', style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
