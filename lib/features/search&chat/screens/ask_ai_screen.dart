import 'dart:async';
import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/search&chat/models/chat_message.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/ai_response_bubble.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/ai_synthesizing_bubble.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/ai_verification_notice_bubble.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/ask_ai_header_card.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/ask_ai_top_bar.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/chat_input_dock.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/scope_picker_bottom_sheet.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/source_viewer_bottom_sheet.dart';
import 'package:knowledge_vault_app/features/search&chat/widgets/user_message_bubble.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class AskAiScreen extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<int>? onNavTap;
  final int currentNavIndex;

  const AskAiScreen({
    super.key,
    this.initialQuery,
    this.onNavTap,
    this.currentNavIndex = 2,
  });

  @override
  State<AskAiScreen> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<AskAiScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  String _activeScope = 'All documents [24 files]';
  bool _isSynthesizing = false;

  @override
  void initState() {
    super.initState();
    _messages = List.from(ChatMessage.initialSampleMessages);

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendMessage(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage(String query) {
    if (query.trim().isEmpty) return;

    final now = DateTime.now();
    final timestamp =
        '${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    final userMessage = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      type: MessageType.user,
      text: query,
      timestamp: timestamp,
    );

    // Remove existing temporary synthesizing placeholder if any
    _messages.removeWhere((m) => m.type == MessageType.aiSynthesizing);

    // Add in-progress synthesizing bubble
    final synthMessage = ChatMessage(
      id: 'synth-${DateTime.now().millisecondsSinceEpoch}',
      type: MessageType.aiSynthesizing,
      text:
          'Synthesizing vector chunks from **${_activeScope.split('[').first.trim()}** and cross-referencing repository memory...',
      timestamp: timestamp,
      synthesizingStatus: 'Matching document embeddings',
      matchingCount: 4,
    );

    setState(() {
      _messages.add(userMessage);
      _messages.add(synthMessage);
      _isSynthesizing = true;
    });

    _scrollToBottom();

    // Simulate smart grounding synthesis after short delay
    Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;

      setState(() {
        _messages.removeWhere((m) => m.type == MessageType.aiSynthesizing);
        _messages.add(_generateAnswerForQuery(query, timestamp));
        _isSynthesizing = false;
      });

      _scrollToBottom();
    });
  }

  ChatMessage _generateAnswerForQuery(String query, String timestamp) {
    final lower = query.toLowerCase();

    if (lower.contains('q3') || lower.contains('takeaway')) {
      return ChatMessage(
        id: 'resp-${DateTime.now().millisecondsSinceEpoch}',
        type: MessageType.aiAnswer,
        text:
            'Key highlights synthesized from the **Q3 Financial Summary**:\n\n'
            '• **Revenue expansion**: Vault ARR grew by **34% YoY**, surpassing the Q3 target model.\n'
            '• **Infrastructure efficiency**: Vector database hosting overhead dropped by **19%** after quantized indexing.\n'
            '• **Retention**: Enterprise net expansion index achieved **118%** across core accounts.',
        timestamp: timestamp,
        tokensInfo: '152 tokens',
        latencyInfo: '38ms',
        sources: const [
          VerifiedSource(
            id: 'src-q3-1',
            title: 'Q3 Financial Summary...',
            documentName: 'Q3 Financial Summary.pdf',
            section: 'Executive Summary • Page 2',
            fileType: 'PDF',
            matchPercentage: 99,
            excerpt:
                'Executive summary of third quarter financial performance across enterprise software tiers and reduced pipeline operational costs.',
            folder: 'Financials',
          ),
          VerifiedSource(
            id: 'src-q3-2',
            title: 'Q3 Board Presentation...',
            documentName: 'Q3 Board Deck.pdf',
            section: 'Slide 14 • Infrastructure Costs',
            fileType: 'PDF',
            matchPercentage: 94,
            excerpt:
                'Quantized vector database caching infrastructure reduced cloud hosting expenses by 19% while lowering latency.',
            folder: 'Financials',
          ),
        ],
      );
    } else if (lower.contains('aes') || lower.contains('key') || lower.contains('crypto')) {
      return ChatMessage(
        id: 'resp-${DateTime.now().millisecondsSinceEpoch}',
        type: MessageType.aiAnswer,
        text:
            'According to **Security Architecture Spec Section 4.1**:\n\n'
            '• **PBKDF2 Derivation**: Passwords generate a 256-bit symmetric key using **600,000 iterations** of HMAC-SHA512.\n'
            '• **Salt Entropy**: 32-byte cryptographic CSPRNG salt applied uniquely per document envelope.\n'
            '• **Hardware Enclave**: Private keys remain sealed within Android Keystore / iOS Secure Enclave with biometric auth gates.',
        timestamp: timestamp,
        tokensInfo: '168 tokens',
        latencyInfo: '44ms',
        sources: const [
          VerifiedSource(
            id: 'src-aes-1',
            title: 'Security Architecture Spec...',
            documentName: 'Security Whitepaper.pdf',
            section: 'Section 4.1 • AES Cryptography',
            fileType: 'PDF',
            matchPercentage: 97,
            excerpt:
                'Envelope encryption specifications utilizing AES-256-GCM authenticated cipher with hardware-backed key storage.',
            folder: 'Engineering',
          ),
        ],
      );
    } else if (lower.contains('latency') || lower.contains('indexing')) {
      return ChatMessage(
        id: 'resp-${DateTime.now().millisecondsSinceEpoch}',
        type: MessageType.aiAnswer,
        text:
            'Benchmarked indexing latencies across chunking strategies from **Benchmarks Spec #402**:\n\n'
            '• **256-token sliding chunks**: Averaged **42ms latency** with 96% semantic recall.\n'
            '• **512-token fixed chunks**: Averaged **68ms latency** with 91% semantic recall.\n'
            '• **1024-token recursive chunks**: Averaged **115ms latency** with higher context coherence for legal docs.',
        timestamp: timestamp,
        tokensInfo: '145 tokens',
        latencyInfo: '36ms',
        sources: const [
          VerifiedSource(
            id: 'src-lat-1',
            title: 'Vector Pipeline Benchmarks...',
            documentName: 'Pipeline Benchmarks.docx',
            section: 'Table 3 • Latency vs Precision',
            fileType: 'DOC',
            matchPercentage: 96,
            excerpt:
                'Comparative evaluation of indexing throughput, token boundaries, and embedding model inference times across 10,000 documents.',
            folder: 'Engineering',
          ),
        ],
      );
    }

    // Default grounded answer for any other question
    return ChatMessage(
      id: 'resp-${DateTime.now().millisecondsSinceEpoch}',
      type: MessageType.aiAnswer,
      text:
          'Based on indexed documents in your Vault, here is the verified assessment for "$query":\n\n'
          '• **Primary finding**: Verified context anchors confirm architecture and documentation parameters are aligned.\n'
          '• **Integration point**: Documented in canonical repository specs with zero runtime conflicts.\n'
          '• **Grounding status**: All citations cross-referenced against active vector embeddings.',
      timestamp: timestamp,
      tokensInfo: '138 tokens',
      latencyInfo: '41ms',
      sources: const [
        VerifiedSource(
          id: 'src-gen-1',
          title: 'Engineering Architecture...',
          documentName: 'Engineering Architecture.docx',
          section: 'Section 3 • Technical Review',
          fileType: 'DOC',
          matchPercentage: 95,
          excerpt:
              'Canonical system review and verification standards for document embeddings and repository storage architecture.',
          folder: 'Engineering',
        ),
      ],
    );
  }

  void _onNoticeActionTap(String actionId) {
    if (actionId == 'upload_plan') {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildUploadSheet(),
      );
    } else if (actionId == 'search_web') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.public, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Web search grounding activated for next query'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _openScopePicker() {
    ScopePickerBottomSheet.show(
      context,
      currentScope: _activeScope,
      onSelect: (newScope) {
        setState(() {
          _activeScope = newScope;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched search scope to $newScope'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }

  void _openSourceViewer(VerifiedSource source) {
    SourceViewerBottomSheet.show(context, source);
  }

  void _onVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.mic, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Listening for voice query... Speak now.'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onAttachDocument() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUploadSheet(),
    );
  }

  Widget _buildUploadSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Upload Document to Vault',
              style: FontPalette.hW700S17.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sync documents into the vector index for instant AI grounding.',
              style: FontPalette.hW400S12.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            _buildUploadOption(
              icon: Icons.picture_as_pdf_rounded,
              iconColor: const Color(0xFFEF4444),
              iconBg: const Color(0xFFFEE2E2),
              title: 'Upload Q4 Marketing Plan (.pdf)',
              subtitle: 'Marketing budget, PPC allocation, campaign spend',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Uploaded "Q4 Marketing Plan.pdf" to Vault!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
            _buildUploadOption(
              icon: Icons.description_rounded,
              iconColor: const Color(0xFF2563EB),
              iconBg: const Color(0xFFDBEAFE),
              title: 'Upload Specification (.docx)',
              subtitle: 'Architecture reviews and technical notes',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FontPalette.hW600S13.copyWith(
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: FontPalette.hW400S11.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
              child: AskAiTopBar(
                onBack: () {
                  if (widget.onNavTap != null) {
                    widget.onNavTap!(0); // Switch to Home
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                onAdd: _onAttachDocument,
                onSelectScope: _openScopePicker,
                activeScope: _activeScope.split('[').first.trim(),
              ),
            ),

            // Scrollable Chat Stream + Header Banner
            Expanded(
              child: ListView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 120),
                children: [
                  // Ask Anything Header Card with 4 prompt chips
                  AskAiHeaderCard(
                    onSelectPrompt: (prompt) {
                      _handleSendMessage(prompt);
                    },
                  ),

                  const SizedBox(height: 18),

                  // Chat Message List
                  ..._messages.map((message) {
                    switch (message.type) {
                      case MessageType.user:
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: UserMessageBubble(
                            text: message.text,
                            timestamp: message.timestamp,
                          ),
                        );

                      case MessageType.aiAnswer:
                        return AiResponseBubble(
                          message: message,
                          onSourceTap: _openSourceViewer,
                          onRegenerate: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Regenerating grounded answer...'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );

                      case MessageType.aiVerificationNotice:
                        return AiVerificationNoticeBubble(
                          message: message,
                          onActionTap: _onNoticeActionTap,
                        );

                      case MessageType.aiSynthesizing:
                        return AiSynthesizingBubble(
                          message: message,
                        );
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      // Docked Bottom Input Bar + Navigation Bar
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floating Pill Input Bar docked above the nav bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: ChatInputDock(
              controller: _inputController,
              activeScope: _activeScope,
              onChangeScope: _openScopePicker,
              onSendMessage: _handleSendMessage,
              onAttach: _onAttachDocument,
              onVoiceTap: _onVoiceSearch,
              isBusy: _isSynthesizing,
            ),
          ),

          // Standard Bottom Navigation Bar
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1.2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.folder_outlined,
                activeIcon: Icons.folder_rounded,
                label: 'Library',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.auto_awesome,
                activeIcon: Icons.auto_awesome,
                label: 'Ask AI',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.tune_rounded,
                activeIcon: Icons.tune_rounded,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = widget.currentNavIndex == index;
    final color =
        isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B);

    return InkWell(
      onTap: () {
        widget.onNavTap?.call(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: isSelected
                ? FontPalette.hW700S12.copyWith(
                    fontSize: 11,
                    color: color,
                  )
                : FontPalette.hW500S10.copyWith(
                    fontSize: 11,
                    color: color,
                  ),
          ),
        ],
      ),
    );
  }
}
