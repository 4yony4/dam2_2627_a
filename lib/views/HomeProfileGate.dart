import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam2_2627_a/DataHolder.dart';
import 'package:dam2_2627_a/FbObjects/Perfil.dart';
import 'package:dam2_2627_a/views/LoginView.dart';
import 'package:dam2_2627_a/views/ProfileView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Carga el perfil antes de construir Home, incluso al refrescar `/HomeView`.
class HomeProfileGate extends StatefulWidget {
  const HomeProfileGate({super.key, required this.homeBuilder});

  final WidgetBuilder homeBuilder;

  @override
  State<HomeProfileGate> createState() => _HomeProfileGateState();
}

class _HomeProfileGateState extends State<HomeProfileGate> {
  late Future<_HomeDestination> _destination;

  @override
  void initState() {
    super.initState();
    _destination = _loadProfile();
  }

  Future<_HomeDestination> _loadProfile() async {
    // Tras un refresh, Firebase Auth puede tardar en restaurar la sesión.
    final user = await FirebaseAuth.instance.authStateChanges().first;
    if (user == null) return _HomeDestination.login;

    final doc = await FirebaseFirestore.instance
        .collection('Perfiles')
        .doc(user.uid)
        .withConverter<Perfil>(
          fromFirestore: Perfil.fromFirestore,
          toFirestore: (perfil, _) => perfil.toFirestore(),
        )
        .get();
    final perfil = doc.data();
    if (perfil == null) return _HomeDestination.profile;

    Dataholder.instance.perfilUsuario = perfil;
    Dataholder.instance.initFirebaseListeners();
    await perfil.descargarMensajes();
    Dataholder.instance.sMessagesBadgeText = perfil.mensajes
        .where((mensaje) => !mensaje.leido)
        .length
        .toString();
    return _HomeDestination.home;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_HomeDestination>(
      future: _destination,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No se pudo cargar el perfil.'),
                  TextButton(
                    onPressed: () => setState(() => _destination = _loadProfile()),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return switch (snapshot.data!) {
          _HomeDestination.login => Loginview(),
          _HomeDestination.profile => Profileview(),
          _HomeDestination.home => widget.homeBuilder(context),
        };
      },
    );
  }
}

enum _HomeDestination { login, profile, home }
