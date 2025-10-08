import 'package:flutter/material.dart';
import 'package:etic_mobile/core/constants.dart';
import 'package:etic_mobile/core/router/app_router.dart';
import 'package:etic_mobile/core/theme/app_theme.dart';
import 'package:etic_mobile/features/auth/presentation/login_screen.dart';
import 'package:etic_mobile/features/home/presentation/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _loggedIn = false;

  void _handleLoginSuccess() {
    setState(() => _loggedIn = true);
  }

  void _handleLogout() {
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);
    setState(() => _loggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    final routes = AppRouter.buildRoutes(onLogout: _handleLogout);

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routes: routes,
      home: _loggedIn
          ? HomeScreen(onLogout: _handleLogout)
          : LoginScreen(onLoginSuccess: _handleLoginSuccess),
      onGenerateRoute: (settings) {
        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute<void>(builder: builder, settings: settings);
        }
        return null;
      },
    );
  }
}
