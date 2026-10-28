import 'package:flutter/material.dart';

/// Displays the application settings modal bottom sheet.
void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'PARAMÈTRES',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.white),
            title: const Text('Langue'),
            trailing: const Text(
              'Français 🇫🇷',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.white),
            title: const Text('Thème'),
            trailing: const Text(
              'Sombre (Red Pinball)',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('Version de l\'application'),
            trailing: const Text(
              '1.0.0 (V1)',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
