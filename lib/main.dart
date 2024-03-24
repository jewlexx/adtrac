import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "counter.dart";
// import "historical.dart";

import 'firebase_options.dart';

const ENABLE_EMULATORS = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode && ENABLE_EMULATORS) {
    try {
      // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8009);
      // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(const MyApp());
}

const String title = "Addiction Tracker";

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
