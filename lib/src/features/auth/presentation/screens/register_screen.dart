import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import '../widgets/arcade_logo_transition.dart';
import '../widgets/auth_text_field.dart';

/// Screen allowing new arcade players to register their credentials.
class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;

  const RegisterScreen({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tokens = await _authRepository.register(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF2E7D32),
            content: Text(
              'Compte créé avec succès ! Bienvenue ${tokens.username ?? _usernameController.text.trim()} !',
            ),
          ),
        );
        Navigator.of(context).pop();
        widget.onRegisterSuccess();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
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
                    const SizedBox(height: 18),
                  ],
                  _buildFormFields(),
                  const SizedBox(height: 28),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                  _buildFooterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const [
        ArcadeLogoTransition(height: 60),
        SizedBox(height: 12),
        Text(
          'NOUVEAU JOUEUR - INSCRIPTION',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE53935),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Rejoignez la communauté mondiale du flipper arcade.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
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
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
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
          labelText: 'GamerTag / Pseudo',
          prefixIcon: Icons.sports_esports_outlined,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Veuillez saisir votre pseudo';
            }
            if (v.trim().length < 3) {
              return 'Au moins 3 caractères requis';
            }
            if (v.contains(' ')) {
              return 'Les espaces ne sont pas autorisés';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        AuthTextField(
          controller: _emailController,
          labelText: 'Adresse Email',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Veuillez saisir votre email';
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
            if (!emailRegex.hasMatch(v.trim())) {
              return 'Format d\'adresse email invalide';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        AuthTextField(
          controller: _passwordController,
          labelText: 'Mot de passe',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'Veuillez saisir un mot de passe';
            }
            if (v.length < 6) {
              return 'Le mot de passe doit comporter au moins 6 caractères';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        AuthTextField(
          controller: _confirmPasswordController,
          labelText: 'Confirmer le mot de passe',
          prefixIcon: Icons.lock_clock_outlined,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleRegister(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'Veuillez confirmer votre mot de passe';
            }
            if (v != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE53935),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        onPressed: _isLoading ? null : _handleRegister,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : const Text(
                'CRÉER MON COMPTE',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }

  Widget _buildFooterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà inscrit ? ',
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Se connecter',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
