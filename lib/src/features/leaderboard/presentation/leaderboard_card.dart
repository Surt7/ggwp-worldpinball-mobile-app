import 'package:flutter/material.dart';

class LeaderboardCard extends StatelessWidget {
  final Map<String, dynamic> entry;

  const LeaderboardCard({super.key, required this.entry});

  Widget _buildRankBadge(int rank) {
    if (rank == 1) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFD700).withValues(alpha: 0.18),
          border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Center(child: Text('🥇', style: TextStyle(fontSize: 22))),
      );
    }
    if (rank == 2) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFC0C0C0).withValues(alpha: 0.15),
          border: Border.all(color: const Color(0xFFC0C0C0), width: 1.5),
        ),
        child: const Center(child: Text('🥈', style: TextStyle(fontSize: 22))),
      );
    }
    if (rank == 3) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFCD7F32).withValues(alpha: 0.15),
          border: Border.all(color: const Color(0xFFCD7F32), width: 1.5),
        ),
        child: const Center(child: Text('🥉', style: TextStyle(fontSize: 22))),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2A2A2A),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rank = entry['rank'] as int? ?? 0;
    final modeName = entry['modeName']?.toString();
    final machineName = entry['machine']?.toString() ?? 'Flipper';

    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: rank <= 3
            ? BorderSide(
                color: rank == 1
                    ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                    : (rank == 2
                          ? const Color(0xFFC0C0C0).withValues(alpha: 0.3)
                          : const Color(0xFFCD7F32).withValues(alpha: 0.3)),
                width: 1.2,
              )
            : BorderSide(color: Colors.grey.shade900),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: _buildRankBadge(rank),
        title: Text(
          entry['player'].toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                machineName,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (modeName != null && modeName.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade700, width: 0.5),
                ),
                child: Text(
                  modeName,
                  style: const TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Text(
          entry['score'].toString(),
          style: const TextStyle(
            color: Color(0xFFE53935),
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
