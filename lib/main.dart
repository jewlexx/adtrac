import "package:flutter/material.dart";
import "package:vapetracker/historical.dart";

import "counter.dart";

void main() {
  runApp(const MyApp());
}

// TODO: Add pages

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: "Vape Tracker"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.numbers),
                  label: Text('Daily Hits'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.date_range),
                  label: Text('Historical Data'),
                ),
              ],
              selectedIndex: selectedPage,
              onDestinationSelected: (value) {
                setState(() => selectedPage = value);
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: selectedPage == 0
                  ? const CounterPage()
                  : const HistoricalPage(),
            ),
          )
        ],
      ),
    );
  }
}
