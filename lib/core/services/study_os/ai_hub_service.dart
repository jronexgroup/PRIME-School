import 'package:flutter/material.dart';

enum AiHubTab {
  courses,
  chatGpt,
  claude,
  gemini,
  notebookLm,
  perplexity,
}

class AiHubService {
  static const Map<AiHubTab, String> tabNames = {
    AiHubTab.courses: 'Courses',
    AiHubTab.chatGpt: 'ChatGPT',
    AiHubTab.claude: 'Claude',
    AiHubTab.gemini: 'Gemini',
    AiHubTab.notebookLm: 'NotebookLM',
    AiHubTab.perplexity: 'Perplexity',
  };

  static const Map<AiHubTab, IconData> tabIcons = {
    AiHubTab.courses: Icons.menu_book_rounded,
    AiHubTab.chatGpt: Icons.smart_toy_rounded,
    AiHubTab.claude: Icons.psychology_rounded,
    AiHubTab.gemini: Icons.auto_awesome_rounded,
    AiHubTab.notebookLm: Icons.note_alt_rounded,
    AiHubTab.perplexity: Icons.search_rounded,
  };

  static const Map<AiHubTab, String> tabUrls = {
    AiHubTab.courses: '', // Courses use internal content
    AiHubTab.chatGpt: 'https://chatgpt.com',
    AiHubTab.claude: 'https://claude.ai',
    AiHubTab.gemini: 'https://gemini.google.com',
    AiHubTab.notebookLm: 'https://notebooklm.google.com',
    AiHubTab.perplexity: 'https://perplexity.ai',
  };

  static const List<String> allowedWebsites = [
    'chatgpt.com',
    'chat.openai.com',
    'claude.ai',
    'gemini.google.com',
    'notebooklm.google.com',
    'perplexity.ai',
    'wikipedia.org',
    'stackoverflow.com',
    'github.com',
    'docs.python.org',
  ];

  static bool isUrlAllowed(String url) {
    for (final allowed in allowedWebsites) {
      if (url.contains(allowed)) return true;
    }
    return false;
  }
}
