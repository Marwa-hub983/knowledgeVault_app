import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _suggestedQuestions = [
    '"What were the key takeaways from Q3..."',
    '"Summarize engineering architecture..."',
    '"List action items from team sync"',
    '"Compare indexing latency across..."',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAddDocument() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add Document action clicked'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onQuestionTap(String question) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Asking: $question'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
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
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top App Bar
                  _buildTopBar(),

                  const SizedBox(height: 16),

                  // Greeting & Profile Row
                  _buildGreetingRow(),

                  const SizedBox(height: 16),

                  // AI Search Bar
                  _buildAiSearchBar(),

                  const SizedBox(height: 16),

                  // Metrics / Stats Row (Documents, Folders, Storage)
                  _buildMetricsRow(),

                  const SizedBox(height: 16),

                  // Processing Pipeline Card
                  _buildProcessingPipelineCard(),

                  const SizedBox(height: 20),

                  // Recent Documents Header & Carousel
                  _buildRecentDocumentsSection(),

                  const SizedBox(height: 22),

                  // Suggested Questions Section
                  _buildSuggestedQuestionsSection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Floating "+ Add Document" Button
          Positioned(
            right: 18,
            bottom: 80,
            child: _buildAddDocumentButton(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Top navigation bar with "Vault / Home" and header actions
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vault',
              style: FontPalette.hW700S17.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              'Home',
              style: FontPalette.hW500S12.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
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
                    Icons.add_rounded,
                    size: 22,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildAvatar(size: 32),
          ],
        ),
      ],
    );
  }

  /// Greeting "Good morning, Marwa" with synced count and large avatar
  Widget _buildGreetingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Marwa',
                style: FontPalette.hW700S22.copyWith(
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'Personal Knowledge Vault',
                      style: FontPalette.hW400S12.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        '•',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '24 items synced',
                      style: FontPalette.hW600S12.copyWith(
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildAvatar(size: 46, showOnlineBadge: true),
      ],
    );
  }

  /// Interactive AI Search Bar with sparkle icon and mic
  Widget _buildAiSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Sparkle circular badge
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: FontPalette.hW500S13.copyWith(
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: 'Ask your vault anything...',
                hintStyle: FontPalette.hW400S14.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listening for voice search...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.mic_none_rounded,
                  size: 20,
                  color: Color(0xFF475569),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3 Metric cards side-by-side: Documents, Folders, Storage
  Widget _buildMetricsRow() {
    return Row(
      children: [
        // Documents Card
        Expanded(
          child: _buildMetricCard(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF6366F1),
            iconBgColor: const Color(0xFFEEF2FF),
            topRightText: '+3',
            topRightColor: const Color(0xFF0D9488),
            statValue: '24',
            label: 'Documents',
          ),
        ),
        const SizedBox(width: 10),

        // Folders Card
        Expanded(
          child: _buildMetricCard(
            icon: Icons.folder_outlined,
            iconColor: const Color(0xFF0D9488),
            iconBgColor: const Color(0xFFCCFBF1),
            topRightText: 'Tidy',
            topRightColor: const Color(0xFF475569),
            statValue: '6',
            label: 'Folders',
          ),
        ),
        const SizedBox(width: 10),

        // Storage Card
        Expanded(
          child: _buildMetricCard(
            icon: Icons.cloud_outlined,
            iconColor: const Color(0xFF475569),
            iconBgColor: const Color(0xFFF1F5F9),
            topRightText: '0.6%',
            topRightColor: const Color(0xFF475569),
            statValue: '120MB',
            label: 'of 20 GB',
          ),
        ),
      ],
    );
  }

  /// Reusable Metric Card
  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String topRightText,
    required Color topRightColor,
    required String statValue,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
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
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: iconColor,
                ),
              ),
              Text(
                topRightText,
                style: FontPalette.hW600S11.copyWith(
                  color: topRightColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              statValue,
              style: FontPalette.hW700S20.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: FontPalette.hW500S12.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  /// Processing Pipeline banner card
  Widget _buildProcessingPipelineCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCCFBF1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sync_rounded,
                          size: 18,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '2 documents processing',
                        style: FontPalette.hW600S13.copyWith(
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Active',
                          style: FontPalette.hW600S11.copyWith(
                            color: const Color(0xFF0F766E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening document queue...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text(
                  'Queue',
                  style: FontPalette.hW600S13.copyWith(
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Extracting text & generating vector emb...',
            style: FontPalette.hW400S12.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.65,
              minHeight: 5,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vector pipeline #104',
                style: FontPalette.hW400S11.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                '65% complete',
                style: FontPalette.hW500S11.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Recent documents header and horizontal scrollable list
  Widget _buildRecentDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent documents',
              style: FontPalette.hW700S17.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Viewing all documents...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: FontPalette.hW600S12.copyWith(
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // PDF Document Card
              _buildDocumentCard(
                fileType: 'PDF',
                title: 'Q3 Financial Summary.pdf',
                subtitle: 'Today, 9:42 AM',
                iconColor: const Color(0xFFEF4444),
                iconBgColor: const Color(0xFFFEE2E2),
                icon: Icons.picture_as_pdf_outlined,
              ),
              const SizedBox(width: 12),

              // DOC Document Card
              _buildDocumentCard(
                fileType: 'DOC',
                title: 'Engineering Architecture.docx',
                subtitle: 'Yesterday',
                iconColor: const Color(0xFF3B82F6),
                iconBgColor: const Color(0xFFDBEAFE),
                icon: Icons.article_outlined,
              ),
              const SizedBox(width: 12),

              // Additional Document Card
              _buildDocumentCard(
                fileType: 'PDF',
                title: 'Product Roadmap 2026.pdf',
                subtitle: '2 days ago',
                iconColor: const Color(0xFFEF4444),
                iconBgColor: const Color(0xFFFEE2E2),
                icon: Icons.picture_as_pdf_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Reusable Document card with Ready badge
  Widget _buildDocumentCard({
    required String fileType,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color iconBgColor,
    required IconData icon,
  }) {
    return Container(
      width: 215,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 11,
                      color: Color(0xFF0D9488),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Ready',
                      style: FontPalette.hW600S11.copyWith(
                        color: const Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontPalette.hW600S13.copyWith(
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: FontPalette.hW400S11.copyWith(
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  /// Suggested questions section
  Widget _buildSuggestedQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.chevron_left_rounded,
              size: 20,
              color: Color(0xFF4F46E5),
            ),
            const SizedBox(width: 4),
            Text(
              'Suggested questions',
              style: FontPalette.hW700S16.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: _suggestedQuestions.map((question) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x060F172A),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _onQuestionTap(question),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            question,
                            style: FontPalette.hW500S13.copyWith(
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.north_east_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Floating "+ Add Document" Button
  Widget _buildAddDocumentButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF3730A3),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x403730A3),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: _onAddDocument,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  'Add Document',
                  style: FontPalette.hW700S14.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation Bar: Home, Library, Ask AI, Settings
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
                icon: Icons.home_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.folder_outlined,
                label: 'Library',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.auto_awesome_outlined,
                label: 'Ask AI',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.tune_rounded,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom Navigation item
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentNavIndex == index;
    final color = isSelected ? const Color(0xFF0F172A) : const Color(0xFF64748B);

    return InkWell(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
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

  /// User avatar builder with graceful fallback and online indicator
  Widget _buildAvatar({required double size, bool showOnlineBadge = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
            ),
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140F172A),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: size * 0.62,
              color: Colors.white,
            ),
          ),
        ),
        if (showOnlineBadge)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.8,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
