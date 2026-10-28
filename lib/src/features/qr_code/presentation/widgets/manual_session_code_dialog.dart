import 'package:flutter/material.dart';
import '../../../games/data/game_session_repository.dart';

// Dialog allowing the player to manually enter a pinball cabinet or session code
class ManualSessionCodeDialog extends StatefulWidget {
  const ManualSessionCodeDialog({super.key});

  @override
  State<ManualSessionCodeDialog> createState() =>
      _ManualSessionCodeDialogState();
}

class _ManualSessionCodeDialogState extends State<ManualSessionCodeDialog> {
  // Controller managing text input for the cabinet/session code
  final TextEditingController _codeController = TextEditingController();

  // Repository communicating with GraphQL backend
  final GameSessionRepository _repository = GameSessionRepository();

  // Loading flag preventing duplicate submissions while request is in flight
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // Submits the entered session code to GraphQL and displays feedback SnackBar
  Future<void> _submitCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final result = await _repository.joinGameSession(code);
      if (!mounted) return;

      Navigator.pop(context); // Close the dialog

      final isSuccess = result['success'] == true;
      final message = result['message']?.toString() ?? 'Session processed.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isSuccess
              ? const Color(0xFF2E7D32)
              : const Color(0xFFC62828),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: const Color(0xFFC62828),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF00E5FF)),
      ),
      title: const Row(
        children: [
          Icon(Icons.pin, color: Color(0xFF00E5FF)),
          SizedBox(width: 10),
          Text(
            'CODE DE PARTIE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saisissez le code de session ou le numéro du flipper :',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            maxLength: 8,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              hintText: 'EX: WP-7842',
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                letterSpacing: 2,
              ),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF00E5FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF00E5FF),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('ANNULER', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E5FF),
            foregroundColor: Colors.black,
          ),
          onPressed: _isLoading ? null : _submitCode,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Text(
                  'VALIDER LE CODE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
