import 'package:etic_mobile/features/sites/domain/site.dart';

class SiteRepository {
  Future<List<Site>> fetchSites() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const <Site>[
      Site(id: 'site-1', name: 'Planta Norte', location: 'Monterrey'),
      Site(id: 'site-2', name: 'Planta Sur', location: 'Guadalajara'),
    ];
  }
}
