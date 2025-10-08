import 'package:flutter/material.dart';
import 'package:etic_mobile/core/constants.dart';
import 'package:etic_mobile/core/utils/validators.dart';
import 'package:etic_mobile/features/auth/data/mock_auth_repository.dart';
import 'package:etic_mobile/features/auth/domain/credentials.dart';

/// Pantalla principal de inicio de sesión del sistema ETIC.
///
/// Permite al usuario autenticarse mediante correo y contraseña.
/// Si las credenciales son válidas, ejecuta la función [onLoginSuccess].
///
/// Esta pantalla usa un formulario con validación, un gradiente de fondo,
/// y muestra un `SnackBar` si las credenciales son incorrectas.
class LoginScreen extends StatefulWidget {
  /// Crea una instancia de [LoginScreen].
  ///
  /// Requiere un callback [onLoginSuccess] que se ejecutará
  /// cuando el inicio de sesión sea exitoso.
  const LoginScreen({super.key, required this.onLoginSuccess});

  /// Callback que se ejecuta cuando el usuario inicia sesión correctamente.
  final VoidCallback onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// Estado interno de [LoginScreen].
///
/// Contiene los controladores de texto, validaciones y la lógica
/// para manejar la autenticación del usuario.
class _LoginScreenState extends State<LoginScreen> {
  /// Llave global para validar el formulario.
  final _formKey = GlobalKey<FormState>();

  /// Controlador del campo de usuario.
  final _userCtrl = TextEditingController();

  /// Controlador del campo de contraseña.
  final _passCtrl = TextEditingController();

  /// Repositorio de autenticación (mock).
  final _authRepository = MockAuthRepository();

  /// Indica si se está procesando el inicio de sesión.
  bool _isLoading = false;

  /// Indica si el campo de contraseña está oculto.
  bool _obscure = true;

  /// Inicia sesión con las credenciales ingresadas.
  ///
  /// Valida el formulario, muestra un `SnackBar` si las credenciales
  /// no son válidas y, en caso exitoso, ejecuta [onLoginSuccess].
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAB0202), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
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
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
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
      ),
    );
  }
}
