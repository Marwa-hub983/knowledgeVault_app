import 'package:flutter/material.dart';

enum MessageType {
  user,
  aiAnswer,
  aiVerificationNotice,
  aiSynthesizing,
}

class VerifiedSource {
  final String id;
  final String title;
  final String documentName;
  final String section;
  final String fileType; // 'PDF', 'DOC', etc.
  final int matchPercentage;
  final String excerpt;
  final String folder;

  const VerifiedSource({
    required this.id,
    required this.title,
    required this.documentName,
    required this.section,
    required this.fileType,
    required this.matchPercentage,
    required this.excerpt,
    this.folder = 'General',
  });
}

class NoticeAction {
  final String id;
  final String label;
  final IconData icon;
  final bool isPrimary;

  const NoticeAction({
    required this.id,
    required this.label,
    required this.icon,
    this.isPrimary = false,
  });
}

class ChatMessage {
  final String id;
  final MessageType type;
  final String text;
  final String timestamp;
  final List<VerifiedSource> sources;
  final List<NoticeAction> noticeActions;
  final String? tokensInfo;
  final String? latencyInfo;
  final String? synthesizingStatus;
  final int? matchingCount;
  final bool isLiked;
  final bool isDisliked;

  const ChatMessage({
    required this.id,
    required this.type,
    required this.text,
    required this.timestamp,
    this.sources = const [],
    this.noticeActions = const [],
    this.tokensInfo,
    this.latencyInfo,
    this.synthesizingStatus,
    this.matchingCount,
    this.isLiked = false,
    this.isDisliked = false,
  });

  ChatMessage copyWith({
    String? id,
    MessageType? type,
    String? text,
    String? timestamp,
    List<VerifiedSource>? sources,
    List<NoticeAction>? noticeActions,
    String? tokensInfo,
    String? latencyInfo,
    String? synthesizingStatus,
    int? matchingCount,
    bool? isLiked,
    bool? isDisliked,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      sources: sources ?? this.sources,
      noticeActions: noticeActions ?? this.noticeActions,
      tokensInfo: tokensInfo ?? this.tokensInfo,
      latencyInfo: latencyInfo ?? this.latencyInfo,
      synthesizingStatus: synthesizingStatus ?? this.synthesizingStatus,
      matchingCount: matchingCount ?? this.matchingCount,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
    );
  }

  /// Initial sample messages directly mirroring the design screenshot
  static List<ChatMessage> get initialSampleMessages => [
        const ChatMessage(
          id: 'msg-1',
          type: MessageType.user,
          text:
              'How is Riverpod 2.0 evaluated compared to BLoC in our engineering review?',
          timestamp: '10:14 AM',
        ),
        const ChatMessage(
          id: 'msg-2',
          type: MessageType.aiAnswer,
          text:
              'In Section 1.2 of the evaluation, **Riverpod 2.0** with static code generation was selected as canonical state architecture over BLoC due to:\n\n'
              '• **Compile-time safety**: Superior verification before runtime via code generation provider inspection.\n'
              '• **Garbage collection**: Demonstrated an estimated **28% reduction** in transient GC sweeps during nested widget rebuilds.\n'
              '• **Simplified mocking**: Streamlined unit testing fixtures without boilerplate reactive streams.',
          timestamp: '10:14 AM',
          tokensInfo: '184 tokens',
          latencyInfo: '42ms',
          sources: [
            VerifiedSource(
              id: 'src-1',
              title: 'Flutter Interview Note...',
              documentName: 'Flutter Interview Notes.pdf',
              section: 'Section 1.2',
              fileType: 'PDF',
              matchPercentage: 98,
              excerpt:
                  'Comprehensive comparison between reactive stream BLoC state machines and Riverpod 2.0 compile-time code-gen providers. Shows memory overhead reduction and zero BuildContext dependency in data layers.',
              folder: 'Engineering',
            ),
            VerifiedSource(
              id: 'src-2',
              title: 'Engineering Architect...',
              documentName: 'Engineering Architecture.docx',
              section: 'Page 8 • Benchmarks',
              fileType: 'DOC',
              matchPercentage: 92,
              excerpt:
                  'Benchmark suite metrics on Android/iOS runtimes: Riverpod 2.0 generated providers yielded 28% lower frame drop and transient memory usage during rapid nested widget trees.',
              folder: 'Architecture',
            ),
          ],
        ),
        const ChatMessage(
          id: 'msg-3',
          type: MessageType.user,
          text: 'What is our Q4 marketing budget allocation for paid search?',
          timestamp: '10:16 AM',
        ),
        const ChatMessage(
          id: 'msg-4',
          type: MessageType.aiVerificationNotice,
          text:
              "I couldn't find information regarding Q4 marketing budget or paid search in your indexed documents. Your repository currently contains technical architecture specs and financial summaries up to Q3.",
          timestamp: '10:16 AM',
          noticeActions: [
            NoticeAction(
              id: 'upload_plan',
              label: 'Upload Q4 Marketing Plan',
              icon: Icons.upload_file_rounded,
              isPrimary: true,
            ),
            NoticeAction(
              id: 'search_web',
              label: 'Search wider web',
              icon: Icons.language_rounded,
              isPrimary: false,
            ),
          ],
        ),
        const ChatMessage(
          id: 'msg-5',
          type: MessageType.aiSynthesizing,
          text:
              'Synthesizing vector chunks from **Core Engineering** and cross-referencing repository memory...',
          timestamp: '10:17 AM',
          synthesizingStatus: 'Matching 5 document embeddings',
          matchingCount: 5,
        ),
      ];
}
