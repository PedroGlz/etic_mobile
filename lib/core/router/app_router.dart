import 'package:flutter/material.dart';
import 'package:etic_mobile/core/router/app_routes.dart';
import 'package:etic_mobile/features/clients/presentation/clients_screen.dart';
import 'package:etic_mobile/features/home/presentation/home_screen.dart';
import 'package:etic_mobile/features/inspections/presentation/inspection_form_screen.dart';
import 'package:etic_mobile/features/inspections/presentation/inspections_list_screen.dart';
import 'package:etic_mobile/features/reports/presentation/reports_screen.dart';
import 'package:etic_mobile/features/settings/presentation/settings_screen.dart';
import 'package:etic_mobile/features/sites/presentation/sites_screen.dart';

class AppRouter {
  const AppRouter._();

  static Map<String, WidgetBuilder> buildRoutes({
    required VoidCallback onLogout,
  }) {
    return <String, WidgetBuilder>{
      AppRoutes.home: (_) => HomeScreen(onLogout: onLogout),
      AppRoutes.inspections: (_) => InspectionsListScreen(),
      AppRoutes.inspectionForm: (_) => const InspectionFormScreen(),
      AppRoutes.sites: (_) => SitesScreen(),
      AppRoutes.clients: (_) => ClientsScreen(),
      AppRoutes.reports: (_) => const ReportsScreen(),
      AppRoutes.settings: (_) => const SettingsScreen(),
    };
  }
}
