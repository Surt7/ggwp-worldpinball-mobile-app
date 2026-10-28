import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/machines_bloc.dart';
import '../bloc/machines_event.dart';
import '../bloc/machines_state.dart';
import 'machine_card.dart';
import 'widgets/claim_machine_bottom_sheet.dart';

/// Screen responsible for displaying the list of user-owned machines.
/// Option A: User -> Device -> Machine
class MachinesScreen extends StatelessWidget {
  const MachinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachinesBloc, MachinesState>(
      builder: (context, state) {
        if (state is MachinesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MachinesLoaded) {
          final machines = state.machines;

          if (machines.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<MachinesBloc>().add(LoadMachinesEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.5)),
                        ),
                        child: const Icon(
                          Icons.videogame_asset_off,
                          size: 48,
                          color: Color(0xFFE53935),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Aucun flipper associé',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Connectez-vous avec votre compte WorldPinball et associez une machine avec sa clé d\'activation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => showClaimMachineBottomSheet(context),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'ASSOCIER UN FLIPPER',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {
                          context.read<MachinesBloc>().add(LoadMachinesEvent());
                        },
                        icon: const Icon(Icons.refresh, color: Colors.grey, size: 18),
                        label: const Text('ACTUALISER', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MachinesBloc>().add(LoadMachinesEvent());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: machines.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    color: const Color(0xFF1E1E1E),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: const Color(0xFFE53935).withValues(alpha: 0.5)),
                    ),
                    child: InkWell(
                      onTap: () => showClaimMachineBottomSheet(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53935).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_circle_outline,
                                color: Color(0xFFE53935),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ASSOCIER UN FLIPPER',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Code WP-XXXXX ou scan QR code',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return MachineCard(machine: machines[index - 1]);
              },
            ),
          );
        }

        if (state is MachinesError) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<MachinesBloc>().add(LoadMachinesEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MachinesBloc>().add(LoadMachinesEvent());
                      },
                      child: const Text('RÉESSAYER'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
