import 'package:flutter/material.dart';

class PromptSuggestion {
  final String id;
  final String query;
  final IconData icon;

  const PromptSuggestion({
    required this.id,
    required this.query,
    required this.icon,
  });

  static const List<PromptSuggestion> defaultSuggestions = [
    PromptSuggestion(
      id: 'q1',
      query: 'What were the key takeaways from Q3?',
      icon: Icons.search_rounded,
    ),
    PromptSuggestion(
      id: 'q2',
      query: 'Explain the Riverpod state architecture',
      icon: Icons.account_tree_outlined,
    ),
    PromptSuggestion(
      id: 'q3',
      query: 'Summarize AES-256 key derivation',
      icon: Icons.key_rounded,
    ),
    PromptSuggestion(
      id: 'q4',
      query: 'Compare indexing latency across chunks',
      icon: Icons.query_stats_rounded,
    ),
  ];
}
