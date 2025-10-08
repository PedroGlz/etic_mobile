import 'package:flutter/material.dart';

class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({super.key});

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _clientCtrl = TextEditingController();
  final _siteCtrl = TextEditingController();

  bool _isSaving = false;

  Future<void> _handleSubmit() async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspección guardada (mock).')),
    );

    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _clientCtrl.dispose();
    _siteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva inspección')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Campo requerido'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientCtrl,
                decoration: const InputDecoration(labelText: 'Cliente'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Campo requerido'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _siteCtrl,
                decoration: const InputDecoration(labelText: 'Sitio'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Campo requerido'
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _handleSubmit,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_isSaving ? 'Guardando...' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
