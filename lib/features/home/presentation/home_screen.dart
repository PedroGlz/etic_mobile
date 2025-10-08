import 'package:flutter/material.dart';
import 'package:etic_mobile/core/router/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<_HomeSection> _sections;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _sections = const <_HomeSection>[
      _HomeSection(
        label: 'Inicio',
        icon: Icons.dashboard_outlined,
        route: AppRoutes.home,
      ),
      _HomeSection(
        label: 'Inspecciones',
        icon: Icons.assignment_outlined,
        route: AppRoutes.inspections,
      ),
      _HomeSection(
        label: 'Sitios',
        icon: Icons.factory_outlined,
        route: AppRoutes.sites,
      ),
      _HomeSection(
        label: 'Clientes',
        icon: Icons.people_alt_outlined,
        route: AppRoutes.clients,
      ),
      _HomeSection(
        label: 'Reportes',
        icon: Icons.bar_chart_outlined,
        route: AppRoutes.reports,
      ),
      _HomeSection(
        label: 'Ajustes',
        icon: Icons.settings_outlined,
        route: AppRoutes.settings,
      ),
    ];
  }

  void _openSection(int index) {
    setState(() => _selectedIndex = index);
    final route = _sections[index].route;
    if (route == AppRoutes.home) {
      return;
    }
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel principal'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                leading: CircleAvatar(child: Icon(Icons.thermostat)),
                title: Text('Inspecciones Térmicas'),
                subtitle: Text('Versión demo'),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _sections.length,
                  itemBuilder: (context, index) {
                    final section = _sections[index];
                    return ListTile(
                      leading: Icon(section.icon),
                      title: Text(section.label),
                      selected: index == _selectedIndex,
                      onTap: () {
                        Navigator.pop(context);
                        _openSection(index);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: const _HomeGrid(),
    );
  }
}

class _HomeGrid extends StatelessWidget {
  const _HomeGrid();

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      _HomeCard(
        label: 'Nueva inspección',
        icon: Icons.add_task_outlined,
        route: AppRoutes.inspections,
      ),
      _HomeCard(
        label: 'Sitios',
        icon: Icons.factory_outlined,
        route: AppRoutes.sites,
      ),
      _HomeCard(
        label: 'Clientes',
        icon: Icons.people_alt_outlined,
        route: AppRoutes.clients,
      ),
      _HomeCard(
        label: 'Reportes',
        icon: Icons.bar_chart_outlined,
        route: AppRoutes.reports,
      ),
      _HomeCard(
        label: 'Ajustes',
        icon: Icons.settings_outlined,
        route: AppRoutes.settings,
      ),
    ];

    final crossAxisCount = MediaQuery.of(context).size.width > 700 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: cards,
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, route),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 42),
              const SizedBox(height: 8),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeSection {
  const _HomeSection({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
