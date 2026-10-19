import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class ChatInputDock extends StatefulWidget {
  final TextEditingController controller;
  final String activeScope;
  final VoidCallback onChangeScope;
  final ValueChanged<String> onSendMessage;
  final VoidCallback onAttach;
  final VoidCallback onVoiceTap;
  final bool isBusy;

  const ChatInputDock({
    super.key,
    required this.controller,
    required this.activeScope,
    required this.onChangeScope,
    required this.onSendMessage,
    required this.onAttach,
    required this.onVoiceTap,
    this.isBusy = false,
  });

  @override
  State<ChatInputDock> createState() => _ChatInputDockState();
}

class _ChatInputDockState extends State<ChatInputDock> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.trim().isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasContent = widget.controller.text.trim().isNotEmpty;
    if (hasContent != _hasText) {
      setState(() {
        _hasText = hasContent;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _handleSend() {
    if (widget.isBusy) return;
    final text = widget.controller.text.trim();
    if (text.isEmpty) return;
    widget.controller.clear();
    widget.onSendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top scope status line: "● Searching in All documents [24 files]   Change"
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981), // Emerald green active indicator
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Searching in ${widget.activeScope}',
                  style: FontPalette.hW500S11.copyWith(
                    color: const Color(0xFF475569),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: widget.onChangeScope,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Change',
                    style: FontPalette.hW600S11.copyWith(
                      color: const Color(0xFF4F46E5),
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Main Input row: Attachment + Text field + Mic + Send button
          Row(
            children: [
              // Attachment paperclip button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onAttach,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.attach_file_rounded,
                      size: 21,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Expanded TextField
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: FontPalette.hW500S13.copyWith(
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask a question about your documents...',
                    hintStyle: FontPalette.hW400S13.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Microphone button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onVoiceTap,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.mic_none_rounded,
                      size: 21,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Send button (Solid purple circle with upward arrow)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.isBusy ? null : _handleSend,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.isBusy
                          ? const Color(0xFF818CF8)
                          : _hasText
                              ? const Color(0xFF4338CA)
                              : const Color(0xFF4F46E5),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x284338CA),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: widget.isBusy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.arrow_upward_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
