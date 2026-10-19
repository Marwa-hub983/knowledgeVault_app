import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/search&chat/models/chat_message.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class AiVerificationNoticeBubble extends StatelessWidget {
  final ChatMessage message;
  final ValueChanged<String> onActionTap;

  const AiVerificationNoticeBubble({
    super.key,
    required this.message,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
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
          // Header: Teal Shield + "Vault AI • Verification Notice" + Timestamp
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFCCFBF1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 15,
                  color: Color(0xFF0D9488),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vault AI • Verification Notice',
                  style: FontPalette.hW700S13.copyWith(
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                message.timestamp,
                style: FontPalette.hW400S11.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Body Notice Text
          Text(
            message.text,
            style: FontPalette.hW400S13.copyWith(
              color: const Color(0xFF334155),
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons: "Upload Q4 Marketing Plan" & "Search wider web"
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: message.noticeActions.map((action) {
              if (action.isPrimary) {
                // Primary Purple Button
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton.icon(
                    onPressed: () => onActionTap(action.id),
                    icon: Icon(action.icon, size: 16, color: Colors.white),
                    label: Text(
                      action.label,
                      style: FontPalette.hW600S13.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4338CA),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                );
              } else {
                // Secondary Subtle Button
                return ElevatedButton.icon(
                  onPressed: () => onActionTap(action.id),
                  icon: Icon(
                    action.icon,
                    size: 16,
                    color: const Color(0xFF334155),
                  ),
                  label: Text(
                    action.label,
                    style: FontPalette.hW600S13.copyWith(
                      color: const Color(0xFF334155),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E8F0),
                    foregroundColor: const Color(0xFF334155),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ],
      ),
    );
  }
}
