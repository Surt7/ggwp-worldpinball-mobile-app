import 'package:flutter/material.dart';

// Arcade-themed glowing card displaying current live game session info
class ActiveSessionCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final bool isLiveConnected;

  const ActiveSessionCard({
    super.key,
    required this.session,
    this.isLiveConnected = false,
  });

  @override
  Widget build(BuildContext context) {
    final machineName = session['machineName']?.toString() ?? 'Flipper';
    final modeName = session['modeName']?.toString() ?? 'Standard';
    final slotNumber = session['slotNumber']?.toString() ?? '1';
    final state = session['state']?.toString() ?? 'InGame';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF122818),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00E676), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E676).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Pulsing live indicator dot
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isLiveConnected
                      ? const Color(0xFF00E676)
                      : const Color(0xFFFFB300),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isLiveConnected ? 'PARTIE EN DIRECT (LIVE)' : 'PARTIE EN COURS',
                style: TextStyle(
                  color: isLiveConnected
                      ? const Color(0xFF00E676)
                      : const Color(0xFFFFB300),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF00E676).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Joueur $slotNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            machineName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.sports_esports, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Mode : $modeName',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
              ),
              const SizedBox(width: 14),
              const Icon(Icons.info_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Statut : $state',
                style: const TextStyle(
                  color: Color(0xFF00E676),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
