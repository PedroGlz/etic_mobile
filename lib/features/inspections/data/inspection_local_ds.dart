import 'package:etic_mobile/features/inspections/domain/finding.dart';
import 'package:etic_mobile/features/inspections/domain/inspection.dart';

class InspectionLocalDataSource {
  final List<Inspection> _items = <Inspection>[
    Inspection(
      id: '1001',
      title: 'Inspección #1001',
      client: 'Demo SA de CV',
      site: 'Planta Norte',
      status: 'Borrador',
      date: DateTime.now(),
      findings: const <Finding>[],
    ),
  ];

  Future<List<Inspection>> fetchInspections() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List<Inspection>.unmodifiable(_items);
  }

  Future<void> upsertInspection(Inspection inspection) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _items.indexWhere((item) => item.id == inspection.id);
    if (index == -1) {
      _items.add(inspection);
    } else {
      _items[index] = inspection;
    }
  }
}
