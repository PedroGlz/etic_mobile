import 'package:flutter/material.dart';
import 'package:etic_mobile/core/router/app_routes.dart';

/// Pantalla principal que actúa como panel de control del sistema.
///
/// Contiene el menú lateral con navegación a las secciones:
/// - Inicio
/// - Inspecciones
/// - Sitios
/// - Clientes
/// - Reportes
/// - Ajustes
///
/// Además, incluye un botón en la AppBar para cerrar sesión.
class HomeScreen extends StatefulWidget {
  /// Crea una instancia de [HomeScreen].
  ///
  /// Requiere un callback [onLogout] que se ejecutará cuando el usuario
  /// presione el botón de cerrar sesión.
  const HomeScreen({super.key, required this.onLogout});

  /// Función que se ejecuta al cerrar sesión.
  final VoidCallback onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Estado interno de [HomeScreen].
///
/// Administra las secciones disponibles en el menú lateral
/// y controla la navegación dentro de la aplicación.
class _HomeScreenState extends State<HomeScreen> {
  late final List<_HomeSection> _sections;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _sections = const <_HomeSection>[
      _HomeSection(
        label: 'Inspección Actual',
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

  /// Cambia la sección seleccionada y navega hacia la ruta correspondiente.
  void _openSection(int index) {
    setState(() => _selectedIndex = index);
    final route = _sections[index].route;

    if (route == AppRoutes.home) return;

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
        backgroundColor: const Color(0xFF202327),
        surfaceTintColor: Colors.transparent,
        child: SafeArea(
          child: ListTileTheme(
            iconColor: Colors.white,
            textColor: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/img_etic_menu.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  title: const Text('ETIC System'),
                  subtitle: const Text('Rafael García'),
                ),
                const Divider(color: Colors.white24),
                Expanded(
                  child: ListView.builder(
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final section = _sections[index];
                      return ListTile(
                        leading: Icon(section.icon),
                        title: Text(section.label),
                        selected: index == _selectedIndex,
                        selectedTileColor: Colors.white12,
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
      ),
      body: const _HomeGrid(),
    );
  }
}

/// Cuadrícula principal que muestra las tarjetas de acceso rápido.
///
/// Incluye accesos a las secciones más utilizadas del sistema
/// como inspecciones, sitios, clientes, reportes y ajustes.
class _HomeGrid extends StatelessWidget {
  const _HomeGrid();

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      const _HomeCard(
        label: 'Nueva inspección',
        icon: Icons.add_task_outlined,
        route: AppRoutes.inspections,
      ),
      const _HomeCard(
        label: 'Sitios',
        icon: Icons.factory_outlined,
        route: AppRoutes.sites,
      ),
      const _HomeCard(
        label: 'Clientes',
        icon: Icons.people_alt_outlined,
        route: AppRoutes.clients,
      ),
      const _HomeCard(
        label: 'Reportes',
        icon: Icons.bar_chart_outlined,
        route: AppRoutes.reports,
      ),
      const _HomeCard(
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

/// Tarjeta individual que representa una sección dentro del [HomeScreen].
///
/// Cada tarjeta contiene un ícono y una etiqueta, y al presionarla
/// navega a la ruta correspondiente mediante [Navigator.pushNamed].
class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.label,
    required this.icon,
    required this.route,
  });

  /// Texto mostrado en la tarjeta.
  final String label;

  /// Ícono principal de la tarjeta.
  final IconData icon;

  /// Ruta a la que se navega al presionar la tarjeta.
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
              Icon(icon, size: 42, color: const Color(0xFF303030)),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF303030),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Representa una sección dentro del menú lateral del [HomeScreen].
///
/// Cada sección contiene un [label], un [icon] y una [route]
/// que define la pantalla a la que se navega.
class _HomeSection {
  const _HomeSection({
    required this.label,
    required this.icon,
    required this.route,
  });

  /// Texto que identifica la sección.
  final String label;

  /// Ícono que representa la sección.
  final IconData icon;

  /// Ruta asociada a la sección.
  final String route;
}
