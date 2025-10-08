import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Tema (pendiente)'),
          ),
          ListTile(
            leading: Icon(Icons.security_outlined),
            title: Text('Permisos (pendiente)'),
          ),
        ],
      ),
    );
  }
}
