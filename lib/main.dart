import "package:flutter/material.dart";

import "counter.dart";
import "historical.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Addiction Tracker",
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      routes: {
        "/": (context) => const CounterPage(),
        "/historical": (context) => const HistoricalPage(),
      },
    );
  }
}
