import 'package:flutter/material.dart';

/// Modal bottom sheet form for pinball owners to register a new machine to their fleet.
class AddMachineModal extends StatefulWidget {
  const AddMachineModal({super.key});

  @override
  State<AddMachineModal> createState() => _AddMachineModalState();
}

class _AddMachineModalState extends State<AddMachineModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController(text: 'Stern Pinball');
  final _activationCodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _manufacturerController.dispose();
    _activationCodeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validated! Will trigger a GraphQL Mutation (addMachine)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registering ${_nameController.text}...'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Keyboard offset
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ADD A PINBALL MACHINE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              // Machine Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Machine Name',
                  hintText: 'e.g., Godzilla Premium',
                  prefixIcon: Icon(Icons.sports_esports),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              // Manufacturer
              TextFormField(
                controller: _manufacturerController,
                decoration: const InputDecoration(
                  labelText: 'Manufacturer',
                  prefixIcon: Icon(Icons.factory),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              // Activation Key
              TextFormField(
                controller: _activationCodeController,
                decoration: const InputDecoration(
                  labelText: 'Activation Code / Key',
                  hintText: 'e.g., WP-9982-X',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('REGISTER MACHINE', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}