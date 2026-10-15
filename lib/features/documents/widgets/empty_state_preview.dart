import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class EmptyStatePreview extends StatefulWidget {
  final bool initiallyExpanded;
  final VoidCallback onAddDocument;

  const EmptyStatePreview({
    super.key,
    this.initiallyExpanded = true,
    required this.onAddDocument,
  });

  @override
  State<EmptyStatePreview> createState() => _EmptyStatePreviewState();
}

class _EmptyStatePreviewState extends State<EmptyStatePreview> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Collapsible Header Row
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.visibility_outlined,
                    size: 19,
                    color: Color(0xFF4F46E5),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Empty State Layout Preview',
                    style: FontPalette.hW700S14.copyWith(
                      color: const Color(0xFF0F172A),
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Body
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Circular illustration with folder + plus and sparkle
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Center circular card
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFEEF2FF),
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x104F46E5),
                                blurRadius: 18,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.create_new_folder_outlined,
                              size: 40,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ),

                        // Sparkle star at top right
                        Positioned(
                          top: 4,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              size: 19,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Bold Title
                  Text(
                    'No documents yet. Add your first one',
                    textAlign: TextAlign.center,
                    style: FontPalette.hW700S17.copyWith(
                      color: const Color(0xFF0F172A),
                      fontSize: 17.5,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Muted Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Upload PDFs, Word docs, notes or links to start building your personal knowledge vault.',
                      textAlign: TextAlign.center,
                      style: FontPalette.hW400S13.copyWith(
                        color: const Color(0xFF64748B),
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // "+ Add document" Pill Button
                  Material(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: widget.onAddDocument,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Add document',
                              style: FontPalette.hW700S14.copyWith(
                                color: Colors.white,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
