import 'package:flutter/material.dart';
import 'package:etic_mobile/features/sites/data/site_repository.dart';
import 'package:etic_mobile/features/sites/domain/site.dart';

class SitesScreen extends StatelessWidget {
  SitesScreen({super.key}) : _repository = SiteRepository();

  final SiteRepository _repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sitios')),
      body: FutureBuilder<List<Site>>(
        future: _repository.fetchSites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final sites = snapshot.data ?? const <Site>[];
          if (sites.isEmpty) {
            return const Center(child: Text('Aún no hay sitios registrados.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: sites.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              final site = sites[index];
              return ListTile(
                leading: const Icon(Icons.factory_outlined),
                title: Text(site.name),
                subtitle: Text(site.location),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO(generated): navegar al detalle del sitio
                },
              );
            },
          );
        },
      ),
    );
  }
}
