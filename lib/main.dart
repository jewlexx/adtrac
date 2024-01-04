import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';

import "counter.dart";
import "historical.dart";
import "common.dart";

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const CounterPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'historical',
          builder: (BuildContext context, GoRouterState state) =>
              const HistoricalPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: title,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
