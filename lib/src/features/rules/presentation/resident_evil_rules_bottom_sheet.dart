import 'package:flutter/material.dart';

/// Representation of a detailed rule entry for Resident Evil: Death Island.
class GameModeRule {
  final String id;
  final String name;
  final String players;
  final String ballRule;
  final String characters;
  final String description;
  final IconData icon;
  final Color accentColor;

  const GameModeRule({
    required this.id,
    required this.name,
    required this.players,
    required this.ballRule,
    required this.characters,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}

/// Official Game Modes from the Resident Evil: Death Island Rulebook.
const List<GameModeRule> kResidentEvilRules = [
  GameModeRule(
    id: 'histoire',
    name: 'Mode Histoire',
    players: '1 à 4 joueurs',
    ballRule: 'Progression scénarisée',
    characters: '6 personnages (selon scénario)',
    description:
        'Retrace le film Resident Evil Death Island où on incarne les personnages (6). On ne peut pas choisir les personnages ; les personnages se choisissent selon le scénario.',
    icon: Icons.menu_book,
    accentColor: Color(0xFFE53935),
  ),
  GameModeRule(
    id: 'survie',
    name: 'Mode Survie',
    players: '1 à 4 joueurs',
    ballRule: '1 seule bille (Mort subite)',
    characters: '5 personnages au choix',
    description:
        'On peut choisir son personnage parmi les 5 personnages principaux. Nous avons une seule bille ; quand la bille est perdue, c\'est Game Over.',
    icon: Icons.shield,
    accentColor: Color(0xFFFF9800),
  ),
  GameModeRule(
    id: 'time_attack',
    name: 'Mode Time Attack',
    players: '1 à 4 joueurs',
    ballRule: '3 billes par partie (Temps limité)',
    characters: '5 personnages au choix',
    description:
        'Faire le plus de points dans un temps déterminé. On peut choisir parmi les 5 personnages principaux. 3 billes par partie.',
    icon: Icons.timer,
    accentColor: Color(0xFF00E5FF),
  ),
  GameModeRule(
    id: 'coop',
    name: 'Mode Co-op',
    players: '2 à 5 joueurs',
    ballRule: 'High score partagé',
    characters: '5 personnages au choix',
    description:
        'Choisir parmi les 5 personnages principaux, cumuler les points de tous les joueurs, high score ensemble par le nombre de joueurs.',
    icon: Icons.people,
    accentColor: Color(0xFF76FF03),
  ),
  GameModeRule(
    id: 'battle_royale',
    name: 'Mode Battle Royale',
    players: '5 à 12 joueurs',
    ballRule: '1 bille par tour (Élimination)',
    characters: 'Choix parmi les personnages',
    description:
        'Choisir parmi les personnages. Une bille par tour ; à chaque tour, le dernier score est éliminé du battle royale, jusqu\'à ce qu\'il n\'en reste qu\'un seul : le vainqueur.',
    icon: Icons.military_tech,
    accentColor: Color(0xFFFF1744),
  ),
  GameModeRule(
    id: 'en_ligne',
    name: 'Mode En Ligne',
    players: 'Multi-joueurs distant',
    ballRule: 'Règles de tournoi',
    characters: 'Tous personnages disponibles',
    description:
        'Versus en ligne, tournois mondiaux et classements inter-flippers.',
    icon: Icons.wifi,
    accentColor: Color(0xFFD500F9),
  ),
];

/// Arcade Bottom Sheet displaying the official Resident Evil Death Island Rulebook.
class ResidentEvilRulesBottomSheet extends StatelessWidget {
  const ResidentEvilRulesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE53935)),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: Color(0xFFE53935),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVRE DES RÈGLES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Resident Evil: Death Island',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF2A2A2A), height: 1),

          // Modes List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: kResidentEvilRules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rule = kResidentEvilRules[index];
                return _buildRuleCard(rule);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard(GameModeRule rule) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: rule.accentColor.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Icon + Players Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: rule.accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(rule.icon, color: rule.accentColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  rule.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: rule.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: rule.accentColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  rule.players,
                  style: TextStyle(
                    color: rule.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Chips for ballRule and characters
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildTag(Icons.sports_baseball, rule.ballRule, Colors.amber),
              _buildTag(Icons.person, rule.characters, Colors.lightBlueAccent),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            rule.description,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
