import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/search&chat/models/chat_message.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class SourceViewerBottomSheet extends StatelessWidget {
  final VerifiedSource source;

  const SourceViewerBottomSheet({
    super.key,
    required this.source,
  });

  static void show(BuildContext context, VerifiedSource source) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SourceViewerBottomSheet(source: source),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = source.fileType.toUpperCase() == 'PDF';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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
          const SizedBox(height: 18),

          // Header: File type + Title + Match badge
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      isPdf ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  source.fileType.toUpperCase(),
                  style: FontPalette.hW700S12.copyWith(
                    color: isPdf
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.documentName,
                      style: FontPalette.hW700S16.copyWith(
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${source.folder} • ${source.section}',
                      style: FontPalette.hW400S12.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${source.matchPercentage}% match',
                  style: FontPalette.hW700S12.copyWith(
                    color: const Color(0xFF0F766E),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Grounded Excerpt Box
          Text(
            'VERIFIED CITATION CHUNK',
            style: FontPalette.hW700S12.copyWith(
              fontSize: 11,
              color: const Color(0xFF64748B),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Text(
              source.excerpt,
              style: FontPalette.hW400S13.copyWith(
                color: const Color(0xFF334155),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action button: Open Full Document
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${source.documentName}...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                'Open Full Document',
                style: FontPalette.hW600S14.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4338CA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
