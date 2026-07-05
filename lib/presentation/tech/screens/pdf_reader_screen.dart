import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/content_rag_service.dart';

class PdfReaderScreen extends StatefulWidget {
  final String title;
  final String assetPath;

  const PdfReaderScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  String? _localPath;
  bool _isLoading = true;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.assetPath.split('/').last}');
      if (!file.existsSync()) {
        if (!mounted) return;
        final data = await DefaultAssetBundle.of(context).load(widget.assetPath);
        await file.writeAsBytes(data.buffer.asUint8List());
      }
      if (!mounted) return;
      setState(() {
        _localPath = file.path;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _showAskAiSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AskAiSheet(controller: controller, pageNumber: _currentPage + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: _totalPages > 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _totalPages,
                  backgroundColor: isDark ? Colors.white10 : Colors.black12,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tech),
                ),
              )
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _localPath == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf, size: 64, color: AppColors.error.withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      Text('Could not load PDF', style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    PDFView(
                      filePath: _localPath!,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: true,
                      pageFling: true,
                      onRender: (pages) => setState(() => _totalPages = pages ?? 0),
                      onViewCreated: (pdfViewController) {},
                      onPageChanged: (page, total) => setState(() {
                        _currentPage = page ?? 0;
                        _totalPages = total ?? 0;
                      }),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 80,
                      child: FloatingActionButton.small(
                        heroTag: 'ask_ai',
                        backgroundColor: AppColors.tech,
                        onPressed: _showAskAiSheet,
                        child: const Icon(Icons.smart_toy_rounded, size: 20),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: _totalPages > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Text(
                'Page ${_currentPage + 1} of $_totalPages',
                style: TextStyle(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            )
          : null,
    );
  }
}

class _AskAiSheet extends StatefulWidget {
  final TextEditingController controller;
  final int pageNumber;

  const _AskAiSheet({required this.controller, required this.pageNumber});

  @override
  State<_AskAiSheet> createState() => _AskAiSheetState();
}

class _AskAiSheetState extends State<_AskAiSheet> {
  bool _isLoading = false;
  String? _answer;

  Future<void> _ask() async {
    final question = widget.controller.text.trim();
    if (question.isEmpty) return;
    setState(() { _isLoading = true; _answer = null; });

    try {
      final rag = context.read<ContentRagService>();
      final answer = await rag.ask('(Page ${widget.pageNumber} of Python Handbook) $question');
      if (mounted) setState(() { _answer = answer; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _answer = 'AI service unavailable. Add API keys in Settings.'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40, height: 4,
            decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black26, borderRadius: BorderRadius.circular(2)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Icon(Icons.smart_toy_rounded, size: 18, color: AppColors.tech),
                const SizedBox(width: 8),
                Text('Ask AI about this PDF', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Page ${widget.pageNumber}', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    style: TextStyle(fontSize: 13, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    decoration: InputDecoration(
                      hintText: 'Ask a question about Python...',
                      hintStyle: TextStyle(fontSize: 12, color: isDark ? Colors.white24 : Colors.black26),
                      filled: true,
                      fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _ask(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(color: AppColors.tech, borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: _isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                    onPressed: _isLoading ? null : _ask,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _answer != null
                ? SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.tech.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.tech.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.smart_toy_rounded, size: 14, color: AppColors.tech),
                              const SizedBox(width: 6),
                              Text('AI Response', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.tech)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(_answer!, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight, height: 1.6)),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.psychology_outlined, size: 40, color: AppColors.tech.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        Text('Ask any question about Python', style: TextStyle(fontSize: 12, color: isDark ? Colors.white24 : Colors.black26)),
                        Text('and the AI will answer based on course content', style: TextStyle(fontSize: 11, color: isDark ? Colors.white12 : Colors.black12)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
