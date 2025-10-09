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
        label: 'Inspeccion Actual',
        icon: Icons.dashboard_outlined,
        route: AppRoutes.home,
      ),
      _HomeSection(
        label: 'Inspecciones',
        icon: Icons.fact_check,
        route: AppRoutes.inspectionForm,
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
            tooltip: 'Cerrar sesion',
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
            selectedColor: const Color.fromARGB(255, 255, 255, 161),
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
                  subtitle: const Text('Rafael Garcia'),
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
      body: _selectedIndex == 0
          ? const _CurrentInspectionSplitView()
          : const _HomeGrid(),
    );
  }
}

class _HomeGrid extends StatelessWidget {
  const _HomeGrid();

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      const _HomeCard(
        label: 'Nueva inspeccion',
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

class _CurrentInspectionSplitView extends StatefulWidget {
  const _CurrentInspectionSplitView();

  @override
  State<_CurrentInspectionSplitView> createState() => _CurrentInspectionSplitViewState();
}

class _CurrentInspectionSplitViewState extends State<_CurrentInspectionSplitView> {
  double _hFrac = 0.6; // 60% arriba, 40% abajo
  double _vFrac = 0.5; // 50% izquierda, 50% derecha

  static const double _minFrac = 0.2;
  static const double _maxFrac = 0.8;
  static const double _handleThickness = 12.0;

  late List<_TreeNode> _nodes;
  final Set<String> _expanded = <String>{};
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _nodes = [
      _TreeNode(
        id: 'i001',
        title: 'Inspeccion 001',
        children: [
          _TreeNode(
            id: 'i001-siteA',
            title: 'Sitio: Planta A',
            children: [
              _TreeNode(id: 'i001-a1', title: 'Area 1', barcode: 'A1-0001', verified: true),
              _TreeNode(id: 'i001-a2', title: 'Area 2', barcode: 'A2-0002', verified: false),
            ],
          ),
          _TreeNode(
            id: 'i001-findings',
            title: 'Hallazgos',
            children: [
              _TreeNode(id: 'i001-sec', title: 'Seguridad', barcode: 'SEC-001', verified: false),
              _TreeNode(id: 'i001-mant', title: 'Mantenimiento', barcode: 'MAN-002', verified: true),
            ],
          ),
        ],
      ),
      _TreeNode(
        id: 'i002',
        title: 'Inspeccion 002',
        children: [
          _TreeNode(id: 'i002-siteB', title: 'Sitio: Planta B', barcode: 'PB-0001', verified: false),
          _TreeNode(id: 'i002-findings', title: 'Hallazgos', barcode: 'HAL-0001', verified: false),
        ],
      ),
    ];
  }

  _TreeNode? _findById(String? id, [List<_TreeNode>? list]) {
    if (id == null) return null;
    final nodes = list ?? _nodes;
    for (final n in nodes) {
      if (n.id == id) return n;
      final found = _findById(id, n.children);
      if (found != null) return found;
    }
    return null;
  }

  bool _removeById(String id, [List<_TreeNode>? list]) {
    final nodes = list ?? _nodes;
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == id) {
        nodes.removeAt(i);
        return true;
      }
      if (_removeById(id, nodes[i].children)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final topHeight = (height * _hFrac).clamp(height * _minFrac, height * _maxFrac);
        final leftWidth = (width * _vFrac).clamp(width * _minFrac, width * _maxFrac);
        final rightWidth = width - leftWidth;
        final bottomHeight = height - topHeight;

        final borderColor = Theme.of(context).dividerColor;

        return Stack(
          children: [
            // Superior izquierdo: Resumen (TreeView)
            Positioned(
              left: 0,
              top: 0,
              width: leftWidth,
              height: topHeight,
              child: _CellPanel(
                title: 'Resumen',
                icon: Icons.info_outline,
                borderColor: borderColor,
                child: _SimpleTreeView(
                  nodes: _nodes,
                  expanded: _expanded,
                  selectedId: _selectedId,
                  onToggle: (id) => setState(() {
                    if (!_expanded.remove(id)) _expanded.add(id);
                  }),
                  onSelect: (id) => setState(() {
                    _selectedId = id;
                  }),
                ),
              ),
            ),

            // Superior derecho: Progreso (Tabla)
            Positioned(
              left: leftWidth,
              top: 0,
              width: rightWidth,
              height: topHeight,
              child: _CellPanel(
                title: 'Progreso',
                icon: Icons.timeline_outlined,
                borderColor: borderColor,
                child: _ProgressTable(
                  children: _findById(_selectedId)?.children ?? const <_TreeNode>[],
                  onDelete: (node) => setState(() {
                    if (_selectedId == node.id) _selectedId = null;
                    _removeById(node.id);
                  }),
                ),
              ),
            ),

            // Inferior: Detalles (placeholder)
            Positioned(
              left: 0,
              top: topHeight,
              width: width,
              height: bottomHeight,
              child: _CellPanel(
                title: 'Detalles',
                icon: Icons.view_list_outlined,
                borderColor: borderColor,
                child: const Center(child: Text('Detalles de la seleccion')),
              ),
            ),

            // Asa vertical
            Positioned(
              left: leftWidth - (_handleThickness / 2),
              top: 0,
              width: _handleThickness,
              height: topHeight,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanUpdate: (details) {
                    setState(() {
                      _vFrac = (_vFrac + details.delta.dx / width).clamp(_minFrac, _maxFrac);
                    });
                  },
                ),
              ),
            ),

            // Asa horizontal
            Positioned(
              left: 0,
              top: topHeight - (_handleThickness / 2),
              width: width,
              height: _handleThickness,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanUpdate: (details) {
                    setState(() {
                      _hFrac = (_hFrac + details.delta.dy / height).clamp(_minFrac, _maxFrac);
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CellPanel extends StatelessWidget {
  const _CellPanel({
    required this.title,
    required this.icon,
    required this.borderColor,
    this.child,
  });

  final String title;
  final IconData icon;
  final Color borderColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TreeNode {
  _TreeNode({
    required this.id,
    required this.title,
    this.barcode,
    this.verified = false,
    List<_TreeNode>? children,
  }) : children = children ?? <_TreeNode>[];

  final String id;
  String title;
  String? barcode;
  bool verified;
  final List<_TreeNode> children;
  bool get isLeaf => children.isEmpty;
}

class _FlatNode {
  const _FlatNode(this.node, this.depth, this.hasChildren, this.expanded);
  final _TreeNode node;
  final int depth;
  final bool hasChildren;
  final bool expanded;
}

class _SimpleTreeView extends StatelessWidget {
  const _SimpleTreeView({
    required this.nodes,
    required this.expanded,
    required this.selectedId,
    required this.onToggle,
    required this.onSelect,
  });

  final List<_TreeNode> nodes;
  final Set<String> expanded;
  final String? selectedId;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onSelect;

  List<_FlatNode> _flatten(List<_TreeNode> nodes, int depth) {
    final out = <_FlatNode>[];
    for (final n in nodes) {
      final hasChildren = n.children.isNotEmpty;
      final isExpanded = expanded.contains(n.id);
      out.add(_FlatNode(n, depth, hasChildren, isExpanded));
      if (hasChildren && isExpanded) {
        out.addAll(_flatten(n.children, depth + 1));
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final flat = _flatten(nodes, 0);
    final selColor = Theme.of(context).colorScheme.primary.withOpacity(0.10);
    return ListView.separated(
      itemCount: flat.length,
      separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.5),
      itemBuilder: (context, index) {
        final item = flat[index];
        final n = item.node;
        final isSelected = selectedId == n.id;
        return Container(
          color: isSelected ? selColor : Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(left: (item.depth * 16).toDouble()),
            child: Row(
              children: [
                if (item.hasChildren)
                  IconButton(
                    tooltip: item.expanded ? 'Contraer' : 'Expandir',
                    visualDensity: VisualDensity.compact,
                    iconSize: 18,
                    onPressed: () => onToggle(n.id),
                    icon: Icon(
                      item.expanded ? Icons.expand_more : Icons.chevron_right,
                    ),
                  )
                else
                  const SizedBox(width: 40),
                Icon(item.hasChildren ? Icons.folder_outlined : Icons.article_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => onSelect(n.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(n.title),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProgressTable extends StatelessWidget {
  const _ProgressTable({required this.children, required this.onDelete});
  final List<_TreeNode> children;
  final ValueChanged<_TreeNode> onDelete;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelLarge;
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              _cell(const Text('Ubicacion'), flex: 3, style: headerStyle),
              _cell(const Text('Codigo de barras'), flex: 2, style: headerStyle),
              _cell(const Text('Estatus'), flex: 2, style: headerStyle),
              _cell(const Text('Op'), flex: 1, style: headerStyle),
            ],
          ),
        ),
        const Divider(height: 0, thickness: 0.5),
        Expanded(
          child: children.isEmpty
              ? const Center(child: Text('Sin elementos'))
              : ListView.separated(
                  itemCount: children.length,
                  separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final n = children[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Row(
                        children: [
                          _cell(Text(n.title), flex: 3),
                          _cell(Text(n.barcode ?? '-'), flex: 2),
                          _cell(
                            Text(n.verified ? 'Verificado' : 'Por verificar',
                                style: TextStyle(
                                  color: n.verified
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                )),
                            flex: 2,
                          ),
                          _cell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                tooltip: 'Eliminar',
                                onPressed: () => onDelete(n),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _cell(Widget child, {required int flex, TextStyle? style}) {
    return Expanded(
      flex: flex,
      child: DefaultTextStyle.merge(
        style: style,
        child: child,
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

