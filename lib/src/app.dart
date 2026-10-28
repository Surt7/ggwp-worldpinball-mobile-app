import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/machines/bloc/machines_bloc.dart';
import 'features/machines/data/machine_repository.dart';
import 'shared/theme/app_theme.dart';

/// Root application widget configuring themes, routing gate and global bloc providers.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Pinball',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (context) => MachinesBloc(MachineRepository()),
        child: const AuthGate(),
      ),
    );
  }
}
