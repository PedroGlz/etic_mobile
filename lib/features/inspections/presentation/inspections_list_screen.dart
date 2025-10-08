import 'package:flutter/material.dart';
import 'package:etic_mobile/core/router/app_routes.dart';
import 'package:etic_mobile/features/inspections/data/inspection_local_ds.dart';
import 'package:etic_mobile/features/inspections/data/inspection_repository.dart';
import 'package:etic_mobile/features/inspections/domain/inspection.dart';

class InspectionsListScreen extends StatelessWidget {
  InspectionsListScreen({super.key})
    : _repository = MockInspectionRepository(InspectionLocalDataSource());

  final InspectionRepository _repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inspecciones')),
      body: FutureBuilder<List<Inspection>>(
        future: _repository.getInspections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final inspections = snapshot.data ?? const <Inspection>[];
          if (inspections.isEmpty) {
            return const Center(
              child: Text('No hay inspecciones registradas.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: inspections.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              final inspection = inspections[index];
              return ListTile(
                leading: const Icon(Icons.assignment_outlined),
                title: Text(inspection.title),
                subtitle: Text(
                  'Estado: ${inspection.status} • Cliente: ${inspection.client}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO(generated): navigate to inspection detail
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.inspectionForm),
        icon: const Icon(Icons.add),
        label: const Text('Nueva inspección'),
      ),
    );
  }
}
