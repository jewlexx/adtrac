import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";

import "counter.dart";
// import "historical.dart";

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      routes: {
        "/": (context) => const CounterPage(),
        // "/historical": (context) => const HistoricalPage(),
      },
    );
  }
}
