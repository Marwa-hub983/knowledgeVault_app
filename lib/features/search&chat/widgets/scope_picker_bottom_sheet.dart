import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';

class ScopeOption {
  final String title;
  final String countDisplay;
  final IconData icon;

  const ScopeOption({
    required this.title,
    required this.countDisplay,
    required this.icon,
  });
}

class ScopePickerBottomSheet extends StatelessWidget {
  final String selectedScope;
  final ValueChanged<String> onSelect;

  const ScopePickerBottomSheet({
    super.key,
    required this.selectedScope,
    required this.onSelect,
  });

  static const List<ScopeOption> availableScopes = [
    ScopeOption(
      title: 'All documents',
      countDisplay: '24 files',
      icon: Icons.folder_copy_outlined,
    ),
    ScopeOption(
      title: 'Core Engineering',
      countDisplay: '8 files',
      icon: Icons.developer_board_rounded,
    ),
    ScopeOption(
      title: 'Financials & Audits',
      countDisplay: '6 files',
      icon: Icons.account_balance_wallet_outlined,
    ),
    ScopeOption(
      title: 'Product & Roadmap',
      countDisplay: '5 files',
      icon: Icons.map_outlined,
    ),
    ScopeOption(
      title: 'Legal & Compliance',
      countDisplay: '5 files',
      icon: Icons.gavel_rounded,
    ),
  ];

  static void show(
    BuildContext context, {
    required String currentScope,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ScopePickerBottomSheet(
        selectedScope: currentScope,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Select Knowledge Scope',
              style: FontPalette.hW700S17.copyWith(
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Limit Vault AI search and grounding to specific folders or archives.',
              style: FontPalette.hW400S12.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            ...availableScopes.map((scope) {
              final isSelected = selectedScope.startsWith(scope.title);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEEF2FF)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF818CF8)
                        : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect('${scope.title} [${scope.countDisplay}]');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            scope.icon,
                            size: 20,
                            color: isSelected
                                ? const Color(0xFF4338CA)
                                : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  scope.title,
                                  style: FontPalette.hW600S13.copyWith(
                                    color: isSelected
                                        ? const Color(0xFF4338CA)
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  scope.countDisplay,
                                  style: FontPalette.hW400S11.copyWith(
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: Color(0xFF4338CA),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
