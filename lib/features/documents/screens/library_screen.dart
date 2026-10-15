import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/features/documents/models/document_item.dart';
import 'package:knowledge_vault_app/features/documents/widgets/document_card.dart';
import 'package:knowledge_vault_app/features/documents/widgets/empty_state_preview.dart';
import 'package:knowledge_vault_app/features/documents/widgets/filter_chips_bar.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class LibraryScreen extends StatefulWidget {
  final ValueChanged<int>? onNavTap;
  final int currentNavIndex;

  const LibraryScreen({
    super.key,
    this.onNavTap,
    this.currentNavIndex = 1,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late List<DocumentItem> _documents;
  String _selectedFilter = 'All';
  bool _isGridView = false;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _sortOption = 'Date (Recent)';

  @override
  void initState() {
    super.initState();
    _documents = List.from(DocumentItem.initialDocuments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtered documents based on active category & search query
  List<DocumentItem> get _filteredDocuments {
    return _documents.where((doc) {
      // Category filter
      if (_selectedFilter == 'PDF' && doc.type != DocumentType.pdf) {
        return false;
      }
      if (_selectedFilter == 'DOCX' && doc.type != DocumentType.docx) {
        return false;
      }
      if (_selectedFilter == 'Notes' && doc.type != DocumentType.txt) {
        return false;
      }
      if (_selectedFilter == 'Links' && doc.type != DocumentType.link) {
        return false;
      }

      // Search query filter
      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final matchesTitle = doc.title.toLowerCase().contains(query);
        final matchesFolder = doc.folder.toLowerCase().contains(query);
        final matchesTags =
            doc.tags.any((tag) => tag.toLowerCase().contains(query));
        return matchesTitle || matchesFolder || matchesTags;
      }

      return true;
    }).toList();
  }

  /// Dynamic filter counts
  List<FilterChipData> get _filterChips {
    final pdfCount =
        _documents.where((d) => d.type == DocumentType.pdf).length;
    final docxCount =
        _documents.where((d) => d.type == DocumentType.docx).length;
    final notesCount =
        _documents.where((d) => d.type == DocumentType.txt).length;
    final linksCount =
        _documents.where((d) => d.type == DocumentType.link).length;

    return [
      FilterChipData(label: 'All', count: _documents.length),
      FilterChipData(label: 'PDF', count: pdfCount),
      FilterChipData(label: 'DOCX', count: docxCount),
      FilterChipData(label: 'Notes', count: notesCount),
      FilterChipData(label: 'Links', count: linksCount),
    ];
  }

  void _onAddDocument() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddDocumentSheet(),
    );
  }

  void _deleteDocument(DocumentItem doc) {
    final index = _documents.indexOf(doc);
    setState(() {
      _documents.remove(doc);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${doc.title}"'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFF5EEAD4),
          onPressed: () {
            setState(() {
              _documents.insert(index, doc);
            });
          },
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final options = [
          'Date (Recent)',
          'Date (Oldest)',
          'Name (A-Z)',
          'File Size (Largest)',
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Sort Documents',
                    style: FontPalette.hW700S17.copyWith(
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map((option) {
                  final isSelected = _sortOption == option;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(
                      option,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFF0F172A),
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Color(0xFF4F46E5),
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _sortOption = option;
                        if (option == 'Date (Recent)') {
                          _documents.sort(
                              (a, b) => b.updatedAt.compareTo(a.updatedAt));
                        } else if (option == 'Date (Oldest)') {
                          _documents.sort(
                              (a, b) => a.updatedAt.compareTo(b.updatedAt));
                        } else if (option == 'Name (A-Z)') {
                          _documents.sort((a, b) => a.title.compareTo(b.title));
                        } else if (option == 'File Size (Largest)') {
                          _documents
                              .sort((a, b) => b.sizeInKb.compareTo(a.sizeInKb));
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDocumentOptions(DocumentItem doc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          doc.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontPalette.hW700S16.copyWith(
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.open_in_new_rounded,
                      color: Color(0xFF334155)),
                  title: const Text('Open document'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening ${doc.title}...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined,
                      color: Color(0xFF334155)),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sharing ${doc.title}')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.drive_file_rename_outline_rounded,
                      color: Color(0xFF334155)),
                  title: const Text('Rename'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded,
                      color: Color(0xFFDC2626)),
                  title: const Text(
                    'Delete',
                    style: TextStyle(color: Color(0xFFDC2626)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteDocument(doc);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 18,
                right: 18,
                top: 10,
                bottom: 110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top App Bar
                  _buildTopBar(),

                  const SizedBox(height: 18),

                  // Large Title & Right-side Controls
                  _buildTitleSection(),

                  // Expandable Search Bar
                  if (_isSearchVisible) ...[
                    const SizedBox(height: 14),
                    _buildSearchBar(),
                  ],

                  const SizedBox(height: 18),

                  // Horizontal Filter Chips
                  _buildFilterChips(),

                  const SizedBox(height: 14),

                  // Sort by & Document Count Row
                  _buildSortAndSummaryRow(),

                  const SizedBox(height: 12),

                  // Document List or Grid
                  _buildDocumentSection(),

                  const SizedBox(height: 12),

                  // Empty State Layout Preview
                  EmptyStatePreview(
                    initiallyExpanded: true,
                    onAddDocument: _onAddDocument,
                  ),
                ],
              ),
            ),
          ),

          // Floating "+ Add" Button
          Positioned(
            right: 18,
            bottom: 82,
            child: _buildAddPillButton(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Top App Bar: Vault Icon & Text + Add Button + Profile Picture
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Vault Icon + Title
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A0F172A),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.folder_copy_outlined,
                  size: 20,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vault',
                  style: FontPalette.hW700S17.copyWith(
                    color: const Color(0xFF0F172A),
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Library',
                  style: FontPalette.hW500S12.copyWith(
                    color: const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right: Plus button + Circular Profile Picture
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _onAddDocument,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.add,
                    size: 22,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildProfileAvatar(size: 34),
          ],
        ),
      ],
    );
  }

  /// Profile Avatar matching the curly-haired user in the screenshot
  Widget _buildProfileAvatar({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: const Color(0xFF6366F1),
          child: Center(
            child: Icon(
              Icons.person,
              size: size * 0.7,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Title Section: "Library", Subtitle, Search button, List/Grid switch
  Widget _buildTitleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Title & Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Library',
                style: FontPalette.hW800S26.copyWith(
                  color: const Color(0xFF0F172A),
                  fontSize: 27,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Your synced personal repository',
                style: FontPalette.hW500S13.copyWith(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        // Actions: Search + List/Grid toggle pill
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    _isSearchVisible = !_isSearchVisible;
                    if (!_isSearchVisible) {
                      _searchController.clear();
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    _isSearchVisible ? Icons.close_rounded : Icons.search,
                    size: 22,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            _buildViewTogglePill(),
          ],
        ),
      ],
    );
  }

  /// List/Grid View Switcher Pill
  Widget _buildViewTogglePill() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // List View Toggle Button
          GestureDetector(
            onTap: () {
              if (_isGridView) {
                setState(() => _isGridView = false);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                color: !_isGridView ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: !_isGridView
                    ? const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.view_agenda_outlined,
                size: 16,
                color: !_isGridView
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFF64748B),
              ),
            ),
          ),

          // Grid View Toggle Button
          GestureDetector(
            onTap: () {
              if (!_isGridView) {
                setState(() => _isGridView = true);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                color: _isGridView ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isGridView
                    ? const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.grid_view_rounded,
                size: 16,
                color: _isGridView
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Expandable Search Bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by title, folder or tag...',
          hintStyle: FontPalette.hW400S13.copyWith(
            color: const Color(0xFF94A3B8),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: Color(0xFF94A3B8),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  /// Horizontal category filter chips
  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: FilterChipsBar(
        filters: _filterChips,
        selectedFilter: _selectedFilter,
        onFilterSelected: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  /// Sort and Summary Row: "Sorted by Date (Recent)" and "24 docs • 120 MB"
  Widget _buildSortAndSummaryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sort Button
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _showSortSheet,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(
                children: [
                  const Icon(
                    Icons.swap_vert_rounded,
                    size: 16,
                    color: Color(0xFF334155),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Sorted by $_sortOption',
                    style: FontPalette.hW600S12.copyWith(
                      color: const Color(0xFF334155),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          // Total docs and size
          Text(
            '${_documents.length} docs • 120 MB',
            style: FontPalette.hW500S12.copyWith(
              color: const Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Document Section: List or Grid view
  Widget _buildDocumentSection() {
    final docs = _filteredDocuments;

    if (docs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Text(
          'No documents match your filter.',
          style: FontPalette.hW500S13.copyWith(
            color: const Color(0xFF64748B),
          ),
        ),
      );
    }

    if (_isGridView) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: docs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.88,
        ),
        itemBuilder: (context, index) {
          final doc = docs[index];
          return _buildGridCard(doc);
        },
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        // In the screenshot, card 3 ("Draft Notes - Oct 14.txt") shows the swipe-to-delete state
        final isSwipePreview =
            (doc.id == 'doc-3' && _selectedFilter == 'All');

        return DocumentCard(
          key: ValueKey(doc.id),
          document: doc,
          isSwipedPreview: isSwipePreview,
          onDelete: () => _deleteDocument(doc),
          onMoreOptions: () => _showDocumentOptions(doc),
        );
      },
    );
  }

  /// Compact Grid Card for Grid View mode
  Widget _buildGridCard(DocumentItem doc) {
    return Container(
      padding: const EdgeInsets.all(12),
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
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: doc.iconContainerBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: doc.iconContainerBorder,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    doc.type == DocumentType.pdf
                        ? Icons.insert_drive_file_outlined
                        : doc.type == DocumentType.docx
                            ? Icons.description_outlined
                            : doc.type == DocumentType.txt
                                ? Icons.sticky_note_2_outlined
                                : Icons.link_rounded,
                    size: 20,
                    color: doc.typeColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, size: 18),
                color: const Color(0xFF64748B),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _showDocumentOptions(doc),
              ),
            ],
          ),
          const Spacer(),
          Text(
            doc.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: FontPalette.hW700S14.copyWith(
              color: const Color(0xFF0F172A),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doc.folder,
            style: FontPalette.hW500S11.copyWith(
              color: const Color(0xFF0D9488),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            doc.dateDisplay,
            style: FontPalette.hW400S11.copyWith(
              color: const Color(0xFF94A3B8),
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Floating "+ Add" pill button matching the screenshot
  Widget _buildAddPillButton() {
    return Material(
      color: const Color(0xFF4F46E5),
      borderRadius: BorderRadius.circular(28),
      elevation: 6,
      shadowColor: const Color(0x404F46E5),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: _onAddDocument,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 22,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              Text(
                'Add',
                style: FontPalette.hW700S14.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation Bar with Home, Library (active), Ask AI, Settings
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
                icon: Icons.auto_awesome_outlined,
                activeIcon: Icons.auto_awesome_rounded,
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

  /// Add Document Bottom Sheet
  Widget _buildAddDocumentSheet() {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Add to Vault',
                style: FontPalette.hW700S17.copyWith(
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select document type or source to sync into your knowledge vault',
                style: FontPalette.hW400S13.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 18),
              _buildAddActionTile(
                icon: Icons.picture_as_pdf_rounded,
                iconColor: const Color(0xFFEF4444),
                iconBg: const Color(0xFFFEE2E2),
                title: 'Upload PDF Document',
                subtitle: 'Financial reports, papers, manuals',
                onTap: () {
                  Navigator.pop(context);
                  _addNewDoc(
                    title: 'New Document.pdf',
                    type: DocumentType.pdf,
                    folder: 'Financials',
                    tags: ['#new', '#pdf'],
                  );
                },
              ),
              _buildAddActionTile(
                icon: Icons.description_rounded,
                iconColor: const Color(0xFF3B82F6),
                iconBg: const Color(0xFFDBEAFE),
                title: 'Upload Word Document (.docx)',
                subtitle: 'Specifications, drafts, proposals',
                onTap: () {
                  Navigator.pop(context);
                  _addNewDoc(
                    title: 'Architecture Doc.docx',
                    type: DocumentType.docx,
                    folder: 'Engineering',
                    tags: ['#spec', '#draft'],
                  );
                },
              ),
              _buildAddActionTile(
                icon: Icons.sticky_note_2_rounded,
                iconColor: const Color(0xFF64748B),
                iconBg: const Color(0xFFF1F5F9),
                title: 'Create Text Note',
                subtitle: 'Quick thoughts, meeting summaries',
                onTap: () {
                  Navigator.pop(context);
                  _addNewDoc(
                    title: 'Meeting Notes.txt',
                    type: DocumentType.txt,
                    folder: 'General',
                    tags: ['#notes', '#meeting'],
                  );
                },
              ),
              _buildAddActionTile(
                icon: Icons.link_rounded,
                iconColor: const Color(0xFF0D9488),
                iconBg: const Color(0xFFCCFBF1),
                title: 'Add Web Link',
                subtitle: 'Documentation, API guides, bookmarks',
                onTap: () {
                  Navigator.pop(context);
                  _addNewDoc(
                    title: 'New Bookmark.link',
                    type: DocumentType.link,
                    folder: 'Engineering',
                    tags: ['#link', '#reference'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewDoc({
    required String title,
    required DocumentType type,
    required String folder,
    required List<String> tags,
  }) {
    final newDoc = DocumentItem(
      id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      type: type,
      folder: folder,
      dateDisplay: 'Just now',
      tags: tags,
      status: DocumentStatus.ready,
      sizeInKb: 2048,
      updatedAt: DateTime.now(),
    );

    setState(() {
      _documents.insert(0, newDoc);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "$title" to Vault'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildAddActionTile({
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
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(14),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: FontPalette.hW600S14.copyWith(
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: FontPalette.hW400S12.copyWith(
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
