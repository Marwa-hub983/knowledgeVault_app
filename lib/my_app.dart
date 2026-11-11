import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_vault_app/shared/routes/route_generator.dart';

class MyApp extends StatefulWidget {
  final bool showOnboarding;

  const MyApp({
    super.key,
    this.showOnboarding = true,
  });

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter router = RouteGenerator.generateRoute(
    showOnboarding: widget.showOnboarding,
  );
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Personal Knowledge Vault App',
      themeMode: _themeMode,
      routerConfig: router,
   
    );
  }
}
