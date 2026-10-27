import 'package:flutter/material.dart';
import 'widgets/add_machine_modal.dart';

/// User Profile screen displaying user info & fleet management.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _openAddMachineModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddMachineModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // User Header Card
        Card(
          color: const Color(0xFF1E1E1E),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFE53935),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tommy_Wizard',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PINBALL OWNER',
                            style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('FR 🇫🇷', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Action: Add Machine Button (Owner Feature)
        ElevatedButton.icon(
          onPressed: () => _openAddMachineModal(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(Icons.add_circle, color: Theme.of(context).colorScheme.primary),
          label: const Text('REGISTER NEW MACHINE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        const SizedBox(height: 24),

        // Owner Fleet List Title
        const Text(
          'MY REGISTERED MACHINES (2)',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.1),
        ),
        const SizedBox(height: 8),

        // Owned Machine 1
        Card(
          color: const Color(0xFF1E1E1E),
          child: ListTile(
            leading: const Icon(Icons.sports_esports, color: Color(0xFFE53935)),
            title: const Text('Resident Evil: Death Island', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Stern Pinball • Online'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ),

        // Owned Machine 2
        Card(
          color: const Color(0xFF1E1E1E),
          child: ListTile(
            leading: const Icon(Icons.sports_esports, color: Color(0xFFE53935)),
            title: const Text('Godzilla Premium', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Stern Pinball • Online'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}