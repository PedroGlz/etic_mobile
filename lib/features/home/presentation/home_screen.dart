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
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 35,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
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
              _TreeNode(
                id: 'i001-a1',
                title: 'Area 1',
                barcode: 'A1-0001',
                verified: true,
                problems: [
                  _Problem(
                    no: 1,
                    fecha: DateTime.now(),
                    numInspeccion: 'INS-001',
                    tipo: 'Térmica',
                    estatus: 'Abierto',
                    cronico: false,
                    tempC: 65.0,
                    deltaTC: 12.3,
                    severidad: 'Media',
                    equipo: 'Motor A',
                    comentarios: 'Vibración leve detectada',
                  ),
                  _Problem(
                    no: 2,
                    fecha: DateTime.now(),
                    numInspeccion: 'INS-001',
                    tipo: 'Eléctrica',
                    estatus: 'Cerrado',
                    cronico: true,
                    tempC: 72.2,
                    deltaTC: 15.0,
                    severidad: 'Alta',
                    equipo: 'Tablero 1',
                    comentarios: 'Ajuste de terminales',
                  ),
                ],
                baselines: [
                  _Baseline(
                    numInspeccion: 'INS-BASE-01',
                    equipo: 'Motor A',
                    fecha: DateTime.now(),
                    mtaC: 40.0,
                    tempC: 42.5,
                    ambC: 22.0,
                    imgR: null,
                    imgD: null,
                    notas: 'Valores dentro de rango',
                  ),
                ],
              ),
              _TreeNode(
                id: 'i001-a2',
                title: 'Area 2',
                barcode: 'A2-0002',
                verified: false,
                problems: [
                  _Problem(
                    no: 1,
                    fecha: DateTime.now(),
                    numInspeccion: 'INS-002',
                    tipo: 'Mecánica',
                    estatus: 'En progreso',
                    cronico: false,
                    tempC: 50.5,
                    deltaTC: 5.5,
                    severidad: 'Baja',
                    equipo: 'Bomba B',
                    comentarios: 'Requiere seguimiento',
                  ),
                ],
                baselines: [
                  _Baseline(
                    numInspeccion: 'INS-BASE-02',
                    equipo: 'Bomba B',
                    fecha: DateTime.now(),
                    mtaC: 38.0,
                    tempC: 39.1,
                    ambC: 23.0,
                    imgR: null,
                    imgD: null,
                    notas: 'OK',
                  ),
                ],
              ),
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
    _nodes.addAll(_generateMockNodes());
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

  List<_TreeNode> _generateMockNodes() {
    final List<_TreeNode> out = [];
    const inspections = 4;
    const sitesPerInspection = 10;
    const areasPerSite = 10;
    const equiposPerArea = 9; // ~4044 nodos totales aprox.

    for (int i = 1; i <= inspections; i++) {
      final insId = i.toString().padLeft(3, '0');
      final inspection = _TreeNode(
        id: 'ins$insId',
        title: 'Inspeccion $insId',
      );

      for (int s = 1; s <= sitesPerInspection; s++) {
        final site = _TreeNode(
          id: 'ins$insId-site$s',
          title: 'Sitio: Planta ${String.fromCharCode(64 + ((s - 1) % 26) + 1)}',
          barcode: 'S$insId-${s.toString().padLeft(3, '0')}',
          verified: s % 2 == 0,
        );

        for (int a = 1; a <= areasPerSite; a++) {
          final area = _TreeNode(
            id: 'ins$insId-site$s-area$a',
            title: 'Area $a',
            barcode: 'A$insId-$s-$a',
            verified: a % 3 == 0,
          );

          for (int e = 1; e <= equiposPerArea; e++) {
            final equipo = _TreeNode(
              id: 'ins$insId-site$s-area$a-e$e',
              title: 'Equipo $e',
              barcode: 'EQ$insId-$s-$a-$e',
              verified: e % 4 == 0,
            );

            if (e == 1) {
              area.problems.add(
                _Problem(
                  no: a * 10 + e,
                  fecha: DateTime.now(),
                  numInspeccion: 'INS-$insId',
                  tipo: 'Termica',
                  estatus: (a % 2 == 0) ? 'Abierto' : 'Cerrado',
                  cronico: a % 4 == 0,
                  tempC: 40 + (e % 10).toDouble(),
                  deltaTC: 5 + (e % 5).toDouble(),
                  severidad: (a % 3 == 0) ? 'Alta' : 'Media',
                  equipo: 'Equipo $e',
                  comentarios: 'Mock generado',
                ),
              );
              area.baselines.add(
                _Baseline(
                  numInspeccion: 'INS-BASE-$insId',
                  equipo: 'Equipo $e',
                  fecha: DateTime.now(),
                  mtaC: 38.0,
                  tempC: 39.0 + (e % 3),
                  ambC: 23.0,
                  imgR: null,
                  imgD: null,
                  notas: 'OK',
                ),
              );
            }

            area.children.add(equipo);
          }

          site.children.add(area);
        }

        inspection.children.add(site);
      }

      out.add(inspection);
    }

    return out;
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

            // Inferior: Detalles (tabs)
            Positioned(
              left: 0,
              top: topHeight,
              width: width,
              height: bottomHeight,
              child: _CellPanel(
                title: 'Detalles',
                icon: Icons.view_list_outlined,
                borderColor: borderColor,
                child: _DetailsTabs(
                  node: _findById(_selectedId),
                  onDeleteProblem: (p) => setState(() {
                    final node = _findById(_selectedId);
                    if (node != null) {
                      node.problems.remove(p);
                    }
                  }),
                  onDeleteBaseline: (b) => setState(() {
                    final node = _findById(_selectedId);
                    if (node != null) {
                      node.baselines.remove(b);
                    }
                  }),
                ),
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
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
          child: child ?? const SizedBox.shrink(),
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
    List<_Problem>? problems,
    List<_Baseline>? baselines,
  })  : children = children ?? <_TreeNode>[],
        problems = problems ?? <_Problem>[],
        baselines = baselines ?? <_Baseline>[];

  final String id;
  String title;
  String? barcode;
  bool verified;
  final List<_TreeNode> children;
  final List<_Problem> problems;
  final List<_Baseline> baselines;
  bool get isLeaf => children.isEmpty;
}

class _Problem {
  _Problem({
    required this.no,
    required this.fecha,
    required this.numInspeccion,
    required this.tipo,
    required this.estatus,
    required this.cronico,
    required this.tempC,
    required this.deltaTC,
    required this.severidad,
    required this.equipo,
    required this.comentarios,
  });

  final int no;
  final DateTime fecha;
  final String numInspeccion;
  final String tipo;
  final String estatus;
  final bool cronico;
  final double tempC;
  final double deltaTC;
  final String severidad;
  final String equipo;
  final String comentarios;
}

class _Baseline {
  _Baseline({
    required this.numInspeccion,
    required this.equipo,
    required this.fecha,
    required this.mtaC,
    required this.tempC,
    required this.ambC,
    this.imgR,
    this.imgD,
    required this.notas,
  });

  final String numInspeccion;
  final String equipo;
  final DateTime fecha;
  final double mtaC;
  final double tempC;
  final double ambC;
  final String? imgR;
  final String? imgD;
  final String notas;
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

class _DetailsTabs extends StatelessWidget {
  const _DetailsTabs({required this.node, required this.onDeleteProblem, required this.onDeleteBaseline});
  final _TreeNode? node;
  final ValueChanged<_Problem> onDeleteProblem;
  final ValueChanged<_Baseline> onDeleteBaseline;

  @override
  Widget build(BuildContext context) {
    final problems = node == null ? const <_Problem>[] : _collectProblems(node!);
    final baselines = node == null ? const <_Baseline>[] : _collectBaselines(node!);
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: const TabBar(
              tabs: [
                Tab(text: 'Listado de problemas'),
                Tab(text: 'Listado Base Line'),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 0.5),
          Expanded(
            child: TabBarView(
              children: [
                _ProblemsTable(problems: problems, onDelete: onDeleteProblem),
                _BaselineTable(baselines: baselines, onDelete: onDeleteBaseline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_Problem> _collectProblems(_TreeNode root) {
    final out = <_Problem>[];
    void dfs(_TreeNode n) {
      out.addAll(n.problems);
      for (final c in n.children) dfs(c);
    }
    dfs(root);
    return out;
  }

  List<_Baseline> _collectBaselines(_TreeNode root) {
    final out = <_Baseline>[];
    void dfs(_TreeNode n) {
      out.addAll(n.baselines);
      for (final c in n.children) dfs(c);
    }
    dfs(root);
    return out;
  }
}

class _ProblemsTable extends StatelessWidget {
  const _ProblemsTable({required this.problems, required this.onDelete});
  final List<_Problem> problems;
  final ValueChanged<_Problem> onDelete;

  String _fmtDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelLarge;
    Widget cell(Widget child, int flex, {TextAlign? align}) => Expanded(
          flex: flex,
          child: Align(alignment: _toAlignment(align), child: child),
        );

    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              cell(const Text('No', overflow: TextOverflow.ellipsis), 1),
              cell(const Text('Fecha'), 2),
              cell(const Text('Num Inspección'), 2),
              cell(const Text('Tipo'), 2),
              cell(const Text('Estatus'), 2),
              cell(const Text('Cronico'), 1),
              cell(const Text('Temp °C'), 1),
              cell(const Text('Delta T °C'), 1),
              cell(const Text('Severidad'), 2),
              cell(const Text('Equipo'), 2),
              cell(const Text('Comentarios'), 3),
              cell(const Text('Op'), 1),
            ],
          ),
        ),
        const Divider(height: 0, thickness: 0.5),
        Expanded(
          child: problems.isEmpty
              ? const Center(child: Text('Sin problemas'))
              : ListView.separated(
                  itemCount: problems.length,
                  separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final p = problems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Row(
                        children: [
                          cell(Text('${p.no}'), 1),
                          cell(Text(_fmtDate(p.fecha)), 2),
                          cell(Text(p.numInspeccion), 2),
                          cell(Text(p.tipo), 2),
                          cell(Text(p.estatus), 2),
                          cell(Icon(p.cronico ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: p.cronico ? Colors.redAccent : Colors.grey, size: 18), 1),
                          cell(Text(p.tempC.toStringAsFixed(1)), 1),
                          cell(Text(p.deltaTC.toStringAsFixed(1)), 1),
                          cell(Text(p.severidad), 2),
                          cell(Text(p.equipo), 2),
                          cell(Text(p.comentarios, overflow: TextOverflow.ellipsis), 3),
                          cell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                tooltip: 'Eliminar',
                                onPressed: () => onDelete(p),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                            1,
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

  Alignment _toAlignment(TextAlign? align) {
    switch (align) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.left:
      default:
        return Alignment.centerLeft;
    }
  }
}

class _BaselineTable extends StatelessWidget {
  const _BaselineTable({required this.baselines, required this.onDelete});
  final List<_Baseline> baselines;
  final ValueChanged<_Baseline> onDelete;

  String _fmtDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelLarge;
    Widget cell(Widget child, int flex) => Expanded(
          flex: flex,
          child: child,
        );
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              cell(const Text('No Inpexxión'), 2),
              cell(const Text('Equipo'), 2),
              cell(const Text('Fecha'), 2),
              cell(const Text('MTA °C'), 1),
              cell(const Text('Temp °C'), 1),
              cell(const Text('Amb °C'), 1),
              cell(const Text('Img R'), 1),
              cell(const Text('Img D'), 1),
              cell(const Text('Notas'), 3),
              cell(const Text('Op'), 1),
            ],
          ),
        ),
        const Divider(height: 0, thickness: 0.5),
        Expanded(
          child: baselines.isEmpty
              ? const Center(child: Text('Sin base line'))
              : ListView.separated(
                  itemCount: baselines.length,
                  separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final b = baselines[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Row(
                        children: [
                          cell(Text(b.numInspeccion), 2),
                          cell(Text(b.equipo), 2),
                          cell(Text(_fmtDate(b.fecha)), 2),
                          cell(Text(b.mtaC.toStringAsFixed(1)), 1),
                          cell(Text(b.tempC.toStringAsFixed(1)), 1),
                          cell(Text(b.ambC.toStringAsFixed(1)), 1),
                          cell(Icon(Icons.image, color: (b.imgR ?? '').isEmpty ? Colors.grey : Colors.blue), 1),
                          cell(Icon(Icons.image, color: (b.imgD ?? '').isEmpty ? Colors.grey : Colors.blue), 1),
                          cell(Text(b.notas, overflow: TextOverflow.ellipsis), 3),
                          cell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                tooltip: 'Eliminar',
                                onPressed: () => onDelete(b),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                            1,
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
