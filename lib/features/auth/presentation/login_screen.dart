import 'package:flutter/material.dart';
import 'package:etic_mobile/core/constants.dart';
import 'package:etic_mobile/core/utils/validators.dart';
import 'package:etic_mobile/features/auth/data/mock_auth_repository.dart';
import 'package:etic_mobile/features/auth/domain/credentials.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLoginSuccess});

  final VoidCallback onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authRepository = MockAuthRepository();

  bool _isLoading = false;
  bool _obscure = true;

  Future<void> _login() async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    setState(() => _isLoading = true);

    final credentials = Credentials(
      email: _userCtrl.text.trim(),
      password: _passCtrl.text,
    );

    final success = await _authRepository.login(credentials);

    if (!mounted) return;

    if (success) {
      widget.onLoginSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/eticLogoLogin.png',
                        height: 56,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _userCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Usuario (email)',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => requiredValidator(value),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) => requiredValidator(value),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Ingresar'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Demo: ${AppConstants.demoEmail} / ${AppConstants.demoPassword}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
