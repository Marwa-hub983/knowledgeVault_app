import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/documents/models/document_item.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class DocumentCard extends StatefulWidget {
  final DocumentItem document;
  final bool isSwipedPreview;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onMoreOptions;

  const DocumentCard({
    super.key,
    required this.document,
    this.isSwipedPreview = false,
    this.onTap,
    this.onDelete,
    this.onMoreOptions,
  });

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  double _dragOffset = 0.0;
  final double _maxActionWidth = 96.0;

  @override
  void initState() {
    super.initState();
    if (widget.isSwipedPreview) {
      _dragOffset = -_maxActionWidth;
    }
  }

  @override
  void didUpdateWidget(covariant DocumentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSwipedPreview != oldWidget.isSwipedPreview) {
      setState(() {
        _dragOffset = widget.isSwipedPreview ? -_maxActionWidth : 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          setState(() {
            _dragOffset = (_dragOffset + details.primaryDelta!)
                .clamp(-_maxActionWidth, 0.0);
          });
        },
        onHorizontalDragEnd: (details) {
          setState(() {
            if (_dragOffset < -_maxActionWidth / 2) {
              _dragOffset = -_maxActionWidth;
            } else {
              _dragOffset = 0.0;
            }
          });
        },
        child: Stack(
          children: [
            // Background Delete Action revealed on swipe left
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              width: _maxActionWidth,
              child: Material(
                color: const Color(0xFFB91C1C), // Deep vibrant red
                child: InkWell(
                  onTap: () {
                    widget.onDelete?.call();
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Delete',
                          style: FontPalette.hW700S12.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Foreground Card Surface
            Transform.translate(
              offset: Offset(_dragOffset, 0),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Document Icon + Title + More Options
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTypeIcon(widget.document),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.document.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FontPalette.hW700S16.copyWith(
                                  color: const Color(0xFF0F172A),
                                  fontSize: 14.5,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.folder_outlined,
                                    size: 14,
                                    color: Color(0xFF0D9488),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.document.folder,
                                    style: FontPalette.hW500S12.copyWith(
                                      color: const Color(0xFF475569),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      '•',
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.document.dateDisplay,
                                    style: FontPalette.hW400S12.copyWith(
                                      color: const Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_dragOffset == -_maxActionWidth)
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.drag_indicator_rounded,
                              size: 18,
                              color: Color(0xFF94A3B8),
                            ),
                          )
                        else
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: widget.onMoreOptions,
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.more_vert_rounded,
                                  size: 19,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Bottom row: Tags and Status badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tags
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: widget.document.tags
                                .map((tag) => _buildTagChip(tag))
                                .toList(),
                          ),
                        ),

                        // Status badge (if available)
                        if (widget.document.status != DocumentStatus.none)
                          _buildStatusBadge(widget.document),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds document type emblem/icon box
  Widget _buildTypeIcon(DocumentItem doc) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: doc.iconContainerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: doc.iconContainerBorder,
          width: 1,
        ),
      ),
      child: Center(
        child: _buildSpecificTypeGlyph(doc.type),
      ),
    );
  }

  Widget _buildSpecificTypeGlyph(DocumentType type) {
    switch (type) {
      case DocumentType.pdf:
        return Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.insert_drive_file_outlined,
              size: 26,
              color: Color(0xFFEF4444),
            ),
            Positioned(
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: const Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFEF4444),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ],
        );
      case DocumentType.docx:
        return const Icon(
          Icons.description_outlined,
          size: 24,
          color: Color(0xFF3B82F6),
        );
      case DocumentType.txt:
        return const Icon(
          Icons.sticky_note_2_outlined,
          size: 24,
          color: Color(0xFF64748B),
        );
      case DocumentType.link:
        return const Icon(
          Icons.link_rounded,
          size: 24,
          color: Color(0xFF0D9488),
        );
    }
  }

  /// Build small tag chip
  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tag,
        style: FontPalette.hW600S11.copyWith(
          color: const Color(0xFF334155),
          fontSize: 11,
        ),
      ),
    );
  }

  /// Build status badge with icon and label
  Widget _buildStatusBadge(DocumentItem doc) {
    IconData icon;
    switch (doc.status) {
      case DocumentStatus.ready:
        icon = Icons.check_circle_outline_rounded;
        break;
      case DocumentStatus.processing:
        icon = Icons.sync_rounded;
        break;
      case DocumentStatus.uploaded:
        icon = Icons.cloud_done_outlined;
        break;
      case DocumentStatus.none:
        icon = Icons.check;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: doc.statusBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: doc.statusColor.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: doc.statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            doc.statusLabel,
            style: FontPalette.hW600S11.copyWith(
              color: doc.statusColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
