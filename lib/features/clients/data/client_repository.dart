import 'package:etic_mobile/features/clients/domain/client.dart';

class ClientRepository {
  Future<List<Client>> fetchClients() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const <Client>[
      Client(id: 'client-1', name: 'Demo SA de CV', industry: 'Manufactura'),
      Client(
        id: 'client-2',
        name: 'Termoeléctrica Nacional',
        industry: 'Energía',
      ),
    ];
  }
}
