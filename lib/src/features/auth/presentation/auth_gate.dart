import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../machines/bloc/machines_bloc.dart';
import '../../machines/bloc/machines_event.dart';
import '../../navigation/presentation/main_navigation_screen.dart';
import '../data/auth_repository.dart';
import 'login_screen.dart';
import 'widgets/arcade_logo_transition.dart';

/// Authentication Gate (Option 1):
/// Guards the application so that only authenticated users access the main navigation.
/// When not authenticated, displays the full-screen Keycloak LoginScreen.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authRepository = AuthRepository();
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final stopwatch = Stopwatch()..start();
    final loggedIn = await _authRepository.isLoggedIn();

    // Ensure the arcade intro sequence plays gracefully (minimum ~2.4 seconds on boot)
    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 2400) {
      await Future.delayed(Duration(milliseconds: 2400 - elapsed));
    }

    if (mounted) {
      setState(() {
        _isAuthenticated = loggedIn;
        _isLoading = false;
      });
      if (loggedIn) {
        context.read<MachinesBloc>().add(LoadMachinesEvent());
      }
    }
  }

  void _onLoginSuccess() {
    setState(() {
      _isAuthenticated = true;
    });
    context.read<MachinesBloc>().add(LoadMachinesEvent());
  }

  void _onLogout() {
    setState(() {
      _isAuthenticated = false;
    });
    context.read<MachinesBloc>().add(LoadMachinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ArcadeLogoTransition(height: 85),
          ),
        ),
      );
    }

    if (!_isAuthenticated) {
      return LoginScreen(onLoginSuccess: _onLoginSuccess);
    }

    return MainNavigationScreen(onLogout: _onLogout);
  }
}
