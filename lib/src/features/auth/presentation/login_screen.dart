import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import 'screens/register_screen.dart';
import 'widgets/arcade_logo_transition.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/forgot_password_dialog.dart';

/// Full-screen authentication gate for World Pinball.
/// Personal features (Machines, Scores, Profile) require a valid Keycloak account.
class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'player1');
  final _passwordController = TextEditingController(text: 'Player123!');
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tokens = await _authRepository.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF2E7D32),
            content: Text(
              'Bienvenue, ${tokens.name ?? tokens.username ?? "Joueur"} !',
            ),
          ),
        );
        widget.onLoginSuccess();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _openForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => const ForgotPasswordDialog(),
    );
  }

  void _openRegisterScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterScreen(
          onRegisterSuccess: widget.onLoginSuccess,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 24.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  if (_errorMessage != null) ...[
                    _buildErrorBanner(),
                    const SizedBox(height: 20),
                  ],
                  _buildFormFields(),
                  const SizedBox(height: 8),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                  const SizedBox(height: 24),
                  _buildRegisterSection(),
                  const SizedBox(height: 20),
                  _buildFooterNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: ArcadeLogoTransition(height: 75),
        ),
        SizedBox(height: 14),
        Text(
          'AUTHENTIFICATION COMPTE JOUEUR',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE53935),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        AuthTextField(
          controller: _usernameController,
          labelText: 'Identifiant ou Email',
          prefixIcon: Icons.person_outline,
          textInputAction: TextInputAction.next,
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Veuillez saisir votre identifiant'
              : null,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          labelText: 'Mot de passe',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleLogin(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (v) => (v == null || v.isEmpty)
              ? 'Veuillez saisir votre mot de passe'
              : null,
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        ),
        onPressed: _openForgotPasswordDialog,
        child: const Text(
          'Mot de passe oublié ?',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53935),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'SE CONNECTER',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ? ',
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: _openRegisterScreen,
          child: const Text(
            'Créer un compte',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterNote() {
    return const Text(
      'Accédez à vos flippers connectés, vos scores certifiés en arcade et synchronisez votre profil mondial.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12,
        height: 1.4,
      ),
    );
  }
}
