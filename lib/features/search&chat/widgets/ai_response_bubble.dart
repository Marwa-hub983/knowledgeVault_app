import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledge_vault_app/features/search&chat/models/chat_message.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class AiResponseBubble extends StatefulWidget {
  final ChatMessage message;
  final ValueChanged<VerifiedSource> onSourceTap;
  final VoidCallback? onRegenerate;
  final ValueChanged<bool>? onLikeChanged;

  const AiResponseBubble({
    super.key,
    required this.message,
    required this.onSourceTap,
    this.onRegenerate,
    this.onLikeChanged,
  });

  @override
  State<AiResponseBubble> createState() => _AiResponseBubbleState();
}

class _AiResponseBubbleState extends State<AiResponseBubble> {
  bool _isLiked = false;
  bool _isDisliked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.message.isLiked;
    _isDisliked = widget.message.isDisliked;
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.message.text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Copied response to clipboard'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Vault AI + Grounded badge + Timestamp
          _buildHeaderRow(),

          const SizedBox(height: 12),

          // Message Body formatted with rich styling
          _buildFormattedText(widget.message.text),

          // Verified Sources Section
          if (widget.message.sources.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'VERIFIED SOURCES',
              style: FontPalette.hW700S12.copyWith(
                fontSize: 11,
                color: const Color(0xFF64748B),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            ...widget.message.sources.map(_buildSourceCard),
          ],

          const SizedBox(height: 14),

          // Action row: Copy, Refresh, Thumbs Up/Down, Token & Latency
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF2FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 14,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Vault AI',
          style: FontPalette.hW700S13.copyWith(
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          '•',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 6),
        // Grounded in X sources badge
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFA7F3D0),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_rounded,
                  size: 11,
                  color: Color(0xFF059669),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Grounded in ${widget.message.sources.length} sources',
                    style: FontPalette.hW600S11.copyWith(
                      color: const Color(0xFF059669),
                      fontSize: 10.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          widget.message.timestamp,
          style: FontPalette.hW400S11.copyWith(
            color: const Color(0xFF94A3B8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFormattedText(String text) {
    // Rich paragraph parsing for bold markdown (**text**) and bullet points
    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.trim().isEmpty) {
          return const SizedBox(height: 8);
        }

        // Render bullet lines with bold highlights
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _renderRichLine(line),
        );
      }).toList(),
    );
  }

  Widget _renderRichLine(String line) {
    final spans = <InlineSpan>[];
    final parts = line.split('**');

    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isEmpty) continue;

      if (i % 2 == 1) {
        // Highlighted bold text
        final isGreenHighlight = part.contains('28% reduction');
        final isRiverpodHighlight = part.contains('Riverpod 2.0');

        spans.add(
          TextSpan(
            text: part,
            style: FontPalette.hW700S13.copyWith(
              color: isGreenHighlight
                  ? const Color(0xFF0D9488)
                  : isRiverpodHighlight
                      ? const Color(0xFF4338CA)
                      : const Color(0xFF0F172A),
              height: 1.45,
            ),
          ),
        );
      } else {
        // Normal text
        spans.add(
          TextSpan(
            text: part,
            style: FontPalette.hW400S13.copyWith(
              color: const Color(0xFF334155),
              height: 1.45,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget _buildSourceCard(VerifiedSource source) {
    final isPdf = source.fileType.toUpperCase() == 'PDF';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => widget.onSourceTap(source),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // File Type Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPdf
                        ? const Color(0xFFFEE2E2)
                        : const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    source.fileType.toUpperCase(),
                    style: FontPalette.hW700S12.copyWith(
                      fontSize: 10,
                      color: isPdf
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF2563EB),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        source.title,
                        style: FontPalette.hW600S12.copyWith(
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${source.documentName} • ${source.section}',
                        style: FontPalette.hW400S11.copyWith(
                          color: const Color(0xFF64748B),
                          fontSize: 10.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Match % badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${source.matchPercentage}% match',
                    style: FontPalette.hW600S11.copyWith(
                      color: const Color(0xFF0F766E),
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        _buildIconButton(
          icon: Icons.copy_rounded,
          onTap: _copyToClipboard,
          tooltip: 'Copy',
        ),
        const SizedBox(width: 4),
        _buildIconButton(
          icon: Icons.refresh_rounded,
          onTap: () => widget.onRegenerate?.call(),
          tooltip: 'Regenerate',
        ),
        const SizedBox(width: 4),
        _buildIconButton(
          icon: _isLiked ? Icons.thumb_up_rounded : Icons.thumb_up_alt_outlined,
          color: _isLiked ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
          onTap: () {
            setState(() {
              _isLiked = !_isLiked;
              if (_isLiked) _isDisliked = false;
            });
            widget.onLikeChanged?.call(_isLiked);
          },
          tooltip: 'Helpful',
        ),
        const SizedBox(width: 4),
        _buildIconButton(
          icon: _isDisliked
              ? Icons.thumb_down_rounded
              : Icons.thumb_down_alt_outlined,
          color:
              _isDisliked ? const Color(0xFFEF4444) : const Color(0xFF64748B),
          onTap: () {
            setState(() {
              _isDisliked = !_isDisliked;
              if (_isDisliked) _isLiked = false;
            });
          },
          tooltip: 'Not helpful',
        ),
        const Spacer(),
        // Token & Latency pill badge: "184 tokens • 42ms"
        if (widget.message.tokensInfo != null ||
            widget.message.latencyInfo != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${widget.message.tokensInfo ?? ''} • ${widget.message.latencyInfo ?? ''}',
              style: FontPalette.hW500S11.copyWith(
                color: const Color(0xFF64748B),
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = const Color(0xFF64748B),
    String tooltip = '',
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
