import 'package:flutter/material.dart';
import '../../features/rules/presentation/resident_evil_rules_bottom_sheet.dart';

/// Representation of a Game Mode for Resident Evil Death Island and arcade filters.
class GameModeItem {
  final String id;
  final String label;
  final IconData icon;

  const GameModeItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

/// Official Game Modes from the Resident Evil Death Island Rulebook
const List<GameModeItem> kGameModes = [
  GameModeItem(id: 'all', label: 'Tous', icon: Icons.sports_esports),
  GameModeItem(id: 'histoire', label: 'Histoire', icon: Icons.menu_book),
  GameModeItem(id: 'survie', label: 'Survie', icon: Icons.shield),
  GameModeItem(id: 'time_attack', label: 'Time Attack', icon: Icons.timer),
  GameModeItem(id: 'coop', label: 'Co-op', icon: Icons.people),
  GameModeItem(id: 'battle_royale', label: 'Battle Royale', icon: Icons.military_tech),
  GameModeItem(id: 'en_ligne', label: 'En ligne', icon: Icons.wifi),
];

/// Horizontal scrollable pill filter bar for Game Modes with License Selector
class GameModeFilterBar extends StatelessWidget {
  final String selectedModeId;
  final ValueChanged<String> onModeSelected;
  final String selectedLicense;
  final ValueChanged<String>? onLicenseSelected;
  final List<String> availableLicenses;

  const GameModeFilterBar({
    super.key,
    required this.selectedModeId,
    required this.onModeSelected,
    this.selectedLicense = 'Resident Evil: Death Island',
    this.onLicenseSelected,
    this.availableLicenses = const [
      'Toutes les licences',
      'Resident Evil: Death Island',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // License selector header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  size: 16,
                  color: Color(0xFFE53935),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LICENCE :',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              // License Chip / Dropdown
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          selectedLicense,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (onLicenseSelected != null) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Rules Book button
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const ResidentEvilRulesBottomSheet(),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE53935).withValues(alpha: 0.6),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book, color: Color(0xFFE53935), size: 14),
                      SizedBox(width: 4),
                      Text(
                        'RÈGLES',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // Horizontal scrollable pills for Game Modes
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: kGameModes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final mode = kGameModes[index];
              final isSelected = mode.id == selectedModeId;

              return InkWell(
                onTap: () => onModeSelected(mode.id),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFE53935)
                        : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF5252)
                          : Colors.grey.shade800,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFE53935).withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        mode.icon,
                        size: 15,
                        color: isSelected ? Colors.white : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        mode.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade300,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
