import 'package:flutter/material.dart';
import 'package:etic_mobile/features/clients/data/client_repository.dart';
import 'package:etic_mobile/features/clients/domain/client.dart';

class ClientsScreen extends StatelessWidget {
  ClientsScreen({super.key}) : _repository = ClientRepository();

  final ClientRepository _repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: FutureBuilder<List<Client>>(
        future: _repository.fetchClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final clients = snapshot.data ?? const <Client>[];
          if (clients.isEmpty) {
            return const Center(
              child: Text('Aún no hay clientes registrados.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: clients.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              final client = clients[index];
              return ListTile(
                leading: const Icon(Icons.people_alt_outlined),
                title: Text(client.name),
                subtitle: Text(client.industry),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO(generated): navegar al detalle del cliente
                },
              );
            },
          );
        },
      ),
    );
  }
}
