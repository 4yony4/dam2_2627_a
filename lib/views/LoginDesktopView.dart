import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/DataHolder.dart';
import 'package:dam2_2627_a/FbObjects/Mensaje.dart';
import 'package:dam2_2627_a/FbObjects/Perfil.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Inicio de sesión para ventanas más anchas que altas.
/// Registra `/LoginDesktopView` y `/HomeDesktopView` en `MiApp` para usarlo.
class LoginDesktopView extends StatefulWidget {
  const LoginDesktopView({super.key});

  @override
  State<LoginDesktopView> createState() => _LoginDesktopViewState();
}

class _LoginDesktopViewState extends State<LoginDesktopView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final user = credential.user;
      if (user == null) throw StateError('No se recibió el usuario');

      final profileRef = FirebaseFirestore.instance
          .collection('Perfiles')
          .doc(user.uid)
          .withConverter<Perfil>(
            fromFirestore: Perfil.fromFirestore,
            toFirestore: (perfil, _) => perfil.toFirestore(),
          );
      final profile = (await profileRef.get()).data();
      if (!mounted) return;
      if (profile == null) {
        Navigator.pushReplacementNamed(context, '/Profileview');
        return;
      }

      Dataholder.instance.perfilUsuario = profile;
      await profile.descargarMensajes();
      Dataholder.instance.sMessagesBadgeText = profile.mensajes
          .where((Mensaje mensaje) => !mensaje.leido)
          .length
          .toString();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/HomeDesktopView');
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(() => _error = error.message ?? 'No se pudo iniciar sesión');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'No se pudo cargar el perfil');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      padding: const EdgeInsets.all(64),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColores.oscuro, AppColores.principal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.forum_rounded,
                            color: Colors.white,
                            size: 72,
                          ),
                          const SizedBox(height: 36),
                          Text(
                            'Tus mensajes,\ncon más espacio.',
                            style: AppTextos.tituloCabecera.copyWith(
                              fontSize: 46,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Consulta tus conversaciones y gestiona tu perfil desde el escritorio.',
                            style: TextStyle(
                              color: AppColores.sobrePrincipalSuave,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Bienvenido de nuevo',
                                style: AppTextos.tituloPantalla.copyWith(
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Inicia sesión para continuar.',
                                style: AppTextos.secundario,
                              ),
                              const SizedBox(height: 32),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  labelText: 'Correo electrónico',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                onSubmitted: (_) => _login(),
                                decoration: const InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: AppColores.error,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              FilledButton(
                                onPressed: _loading ? null : _login,
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Iniciar sesión'),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () => Navigator.pushReplacementNamed(
                                        context,
                                        '/RegisterView',
                                      ),
                                child: const Text('Crear una cuenta'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
