import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/DataHolder.dart';
import 'package:dam2_2627_a/insLib/theme/AppTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

/// Pantalla principal de escritorio con navegación lateral y contenido en columnas.
/// Registra `/HomeDesktopView` y `/LoginDesktopView` en `MiApp` para usarla.
class HomeDesktopView extends StatefulWidget {
  const HomeDesktopView({super.key});

  @override
  State<HomeDesktopView> createState() => _HomeDesktopViewState();
}

class _HomeDesktopViewState extends State<HomeDesktopView> {
  final _nameController = TextEditingController();
  final _phoneMask = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  late String _name;
  bool _saving = false;
  bool _notificationBadge = Dataholder.instance.blNotificacionesBadge;

  @override
  void initState() {
    super.initState();
    _name = Dataholder.instance.perfilUsuario.name ?? '';
    _nameController.text = _name;
    Dataholder.instance.iBotBarIndex = 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final perfil = Dataholder.instance.perfilUsuario;
      final name = _nameController.text.trim();
      await FirebaseFirestore.instance
          .collection('Perfiles')
          .doc(perfil.uid)
          .set({'name': name}, SetOptions(merge: true));
      perfil.name = name;
      if (!mounted) return;
      setState(() => _name = name);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nombre actualizado')));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el nombre')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _openProfile() async {
    await Navigator.pushNamed(context, '/EditProfileview');
    if (!mounted) return;
    setState(() {
      _name = Dataholder.instance.perfilUsuario.name ?? '';
      _nameController.text = _name;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/LoginDesktopView');
  }

  void _openMessages() {
    Dataholder.instance.sMessagesBadgeText = '';
    Navigator.pushNamed(context, '/Messagesview');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 248,
              color: AppColores.oscuro,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Icon(
                          Icons.forum_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'MI APP DAM2627',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColores.pastillaBorde),
                  ListTile(
                    selected: true,
                    selectedTileColor: AppColores.pastilla,
                    leading: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Inicio',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Badge(
                      isLabelVisible:
                          Dataholder.instance.sMessagesBadgeText.isNotEmpty,
                      label: Text(Dataholder.instance.sMessagesBadgeText),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'Mensajes',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: _openMessages,
                  ),
                  ListTile(
                    leading: Badge(
                      isLabelVisible: _notificationBadge,
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text(
                      'Notificaciones',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => setState(() {
                      _notificationBadge = false;
                      Dataholder.instance.blNotificacionesBadge = false;
                    }),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Editar perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: _openProfile,
                  ),
                  const Spacer(),
                  const Divider(color: AppColores.pastillaBorde),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: _logout,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Panel principal',
                              style: AppTextos.tituloPantalla.copyWith(
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser?.email ?? '',
                              style: AppTextos.secundario,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(36),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppRadios.tarjeta,
                            ),
                            gradient: const LinearGradient(
                              colors: [AppColores.principal, AppColores.oscuro],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.waving_hand_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Bienvenido, $_name',
                                style: AppTextos.tituloCabecera.copyWith(
                                  fontSize: 34,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tu espacio para consultar mensajes y actualizar tu perfil.',
                                style: TextStyle(
                                  color: AppColores.sobrePrincipalSuave,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _profileCard()),
                            const SizedBox(width: 24),
                            Expanded(flex: 2, child: _quickAccessCard()),
                          ],
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
    );
  }

  Widget _profileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Datos del perfil',
              style: AppTextos.tituloLista.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cambia tu nombre o abre la edición completa del perfil.',
              style: AppTextos.secundario,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.phone,
              inputFormatters: [_phoneMask],
              decoration: const InputDecoration(
                labelText: 'Teléfono de ejemplo',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const Text('PIN de ejemplo', style: AppTextos.secundario),
            const SizedBox(height: 8),
            SizedBox(
              height: 64,
              child: PinInputTextField(
                pinLength: 4,
                keyboardType: TextInputType.number,
                decoration: CirclePinDecoration(
                  strokeColorBuilder: PinListenColorBuilder(
                    AppColores.oscuro,
                    AppColores.bordeCampo,
                  ),
                  bgColorBuilder: FixedColorBuilder(AppColores.fondo),
                  obscureStyle: ObscureStyle(
                    isTextObscure: true,
                    obscureText: '😈',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _saveName,
              child: Text(_saving ? 'Guardando...' : 'Guardar nombre'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAccessCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Accesos rápidos',
              style: AppTextos.tituloLista.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              'Elige una sección desde aquí o desde el menú lateral.',
              style: AppTextos.secundario,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _openMessages,
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Ver mensajes'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _openProfile,
              icon: const Icon(Icons.person_outline),
              label: const Text('Editar perfil'),
            ),
            const SizedBox(height: 12),
            Text(
              'Mensajes sin leer: ${Dataholder.instance.sMessagesBadgeText.isEmpty ? '0' : Dataholder.instance.sMessagesBadgeText}',
              style: AppTextos.secundario,
            ),
          ],
        ),
      ),
    );
  }
}
