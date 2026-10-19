import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/search&chat/models/chat_message.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class AiSynthesizingBubble extends StatefulWidget {
  final ChatMessage message;

  const AiSynthesizingBubble({
    super.key,
    required this.message,
  });

  @override
  State<AiSynthesizingBubble> createState() => _AiSynthesizingBubbleState();
}

class _AiSynthesizingBubbleState extends State<AiSynthesizingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Flask icon + "Vault AI is synthesizing..."
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEF2FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.science_outlined,
                  size: 15,
                  color: Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Vault AI is synthesizing...',
                style: FontPalette.hW700S13.copyWith(
                  color: const Color(0xFF4338CA),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Body text with bold highlights
          _buildRichSynthesisText(widget.message.text),

          const SizedBox(height: 14),

          // Animated dots & status indicator: "● ● ●  Matching 5 document embeddings"
          Row(
            children: [
              _buildAnimatedDots(),
              const SizedBox(width: 10),
              Text(
                widget.message.synthesizingStatus ??
                    'Matching 5 document embeddings',
                style: FontPalette.hW500S12.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRichSynthesisText(String text) {
    final spans = <InlineSpan>[];
    final parts = text.split('**');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      if (i % 2 == 1) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: FontPalette.hW700S13.copyWith(
              color: const Color(0xFF0F172A),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: parts[i],
            style: FontPalette.hW400S13.copyWith(
              color: const Color(0xFF475569),
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildAnimatedDots() {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.25;
            final progress = (_animController.value - delay) % 1.0;
            final scale = 0.5 + 0.5 * (1.0 - (progress - 0.5).abs() * 2);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4F46E5).withValues(alpha: scale.clamp(0.2, 1.0)),
              ),
            );
          }),
        );
      },
    );
  }
}
