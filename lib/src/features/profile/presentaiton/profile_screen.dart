import 'package:flutter/material.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/widgets/login_modal.dart';
import '../data/profile_repository.dart';
import 'widgets/add_machine_modal.dart';

/// User Profile screen displaying real profile info from WorldPinball backend and Keycloak Auth state.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileRepository = ProfileRepository();
  final _authRepository = AuthRepository();

  bool _isLoggedIn = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final loggedIn = await _authRepository.isLoggedIn();
    final username = await _authRepository.getUsername();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _username = username;
      });
    }
  }

  void _openLoginModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LoginModal(
        onLoginSuccess: () {
          _checkAuthState();
          setState(() {});
        },
      ),
    );
  }

  Future<void> _handleLogout() async {
    await _authRepository.logout();
    await _checkAuthState();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Déconnecté de Keycloak avec succès.')),
      );
    }
  }

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
    return FutureBuilder<Map<String, dynamic>?>(
      future: _profileRepository.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur API: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _openAddMachineModal(context),
                    icon: const Icon(Icons.add_circle),
                    label: const Text('ENREGISTRER UN FLIPPER'),
                  ),
                ],
              ),
            ),
          );
        }

        final profile = snapshot.data;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Keycloak Auth Status Banner
            Card(
              color: _isLoggedIn ? const Color(0xFF1B382B) : const Color(0xFF2C2416),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _isLoggedIn ? Colors.green.shade600 : Colors.amber.shade700,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Icon(
                      _isLoggedIn ? Icons.verified_user : Icons.lock_outline,
                      color: _isLoggedIn ? Colors.greenAccent : Colors.amberAccent,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isLoggedIn
                                ? 'Keycloak IAM : Connecté'
                                : 'Keycloak IAM : Non authentifié',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _isLoggedIn ? Colors.greenAccent : Colors.amberAccent,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _isLoggedIn
                                ? 'Compte : ${_username ?? "player1"} (Token JWT actif)'
                                : 'Connectez-vous pour réclamer et activer vos flippers',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!_isLoggedIn)
                      TextButton(
                        onPressed: () => _openLoginModal(context),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFE53935),
                          backgroundColor: Colors.white10,
                        ),
                        child: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white70, size: 20),
                        tooltip: 'Déconnexion Keycloak',
                        onPressed: _handleLogout,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?['displayName']?.toString() ?? 'Opérateur WorldPinball',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PINBALL OWNER',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                profile?['countryCode']?.toString() ?? 'FR 🇫🇷',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section Info
            Card(
              color: const Color(0xFF1E1E1E),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge, color: Colors.white),
                    title: const Text('Identifiant'),
                    trailing: Text(
                      profile?['userId']?.toString() ?? 'Session Active',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.public, color: Colors.white),
                    title: const Text('Profil Public'),
                    trailing: Text(
                      profile?['isProfilePublic'] == true ? 'Activé' : 'Privé',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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
              label: const Text(
                'ENREGISTRER UN FLIPPER',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }
}
