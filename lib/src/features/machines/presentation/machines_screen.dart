import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/machines_bloc.dart';
import '../bloc/machines_event.dart';
import '../bloc/machines_state.dart';
import 'machine_card.dart';

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
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          context.read<MachinesBloc>().add(LoadMachinesEvent());
                        },
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text('ACTUALISER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              itemCount: machines.length,
              itemBuilder: (context, index) {
                return MachineCard(machine: machines[index]);
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
