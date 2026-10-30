import 'package:flutter/material.dart';
import '../../data/auth_repository.dart';
import 'auth_text_field.dart';

/// Arcade modal dialog allowing players to request a password reset email.
class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authRepository.requestPasswordReset(email: _emailController.text);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        // Auto-close dialog after displaying confirmation feedback
        await Future.delayed(const Duration(milliseconds: 1800));
        if (mounted) {
          Navigator.of(context).pop();
        }
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
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: _isSuccess ? _buildSuccessView() : _buildFormView(),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade900.withValues(alpha: 0.3),
            border: Border.all(color: Colors.greenAccent, width: 1.5),
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.greenAccent,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'INSTRUCTIONS ENVOYÉES',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Un lien de réinitialisation sécurisé a été transmis à l\'adresse ${_emailController.text.trim()}.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  color: Color(0xFFE53935),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'RÉINITIALISATION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Entrez votre adresse email de joueur pour recevoir le lien de réinitialisation de votre mot de passe.',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
          ],
          AuthTextField(
            controller: _emailController,
            labelText: 'Adresse Email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
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
          const SizedBox(height: 22),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'ENVOYER LES INSTRUCTIONS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
