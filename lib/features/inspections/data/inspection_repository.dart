import 'package:etic_mobile/features/inspections/data/inspection_local_ds.dart';
import 'package:etic_mobile/features/inspections/domain/inspection.dart';

abstract class InspectionRepository {
  Future<List<Inspection>> getInspections();
  Future<void> saveInspection(Inspection inspection);
}

class MockInspectionRepository implements InspectionRepository {
  MockInspectionRepository(this._localDataSource);

  final InspectionLocalDataSource _localDataSource;

  @override
  Future<List<Inspection>> getInspections() {
    return _localDataSource.fetchInspections();
  }

  @override
  Future<void> saveInspection(Inspection inspection) {
    return _localDataSource.upsertInspection(inspection);
  }
}
