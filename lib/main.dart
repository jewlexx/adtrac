import "package:flutter/material.dart";

import "common.dart";
import "historical.dart";
import "counter.dart";
import "data.dart";

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
      home: const Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final Future<Counter> _vapeCount = Counter.init();
  int? lastSelectedPage;
  int selectedPage = 0;

  void setPage(int page) {
    lastSelectedPage = selectedPage;
    selectedPage = page;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _vapeCount,
        builder: (BuildContext ctx, AsyncSnapshot<Counter> snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(title),
              ),
              body: const Center(child: Text("Loading Data...")),
            );
          }

          Counter counter = snapshot.data!;

          return WillPopScope(
            onWillPop: () async {
              if (lastSelectedPage == null) {
                return true;
              } else {
                setState(() {
                  selectedPage = lastSelectedPage!;
                  lastSelectedPage = null;
                });
                return false;
              }
            },
            child: Scaffold(
              // appBar: AppBar(
              //   title: const Text(title),
              // ),
              body: CounterPage(counter: counter),
              // selectedPage == 0
              //     ? CounterPage(counter: counter)
              //     : HistoricalPage(counter: counter),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedPage,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.numbers),
                    label: 'Today\'s Hits',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: 'Past Hits',
                  ),
                ],
                onTap: (value) => setState(
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoricalPage(),
                      ),
                    );
                  },
                ),
              ),
              floatingActionButton: selectedPage == 1
                  ? FloatingActionButton(
                      onPressed: counter.export,
                      child: const Icon(Icons.share),
                    )
                  : null,
            ),
          );
        });
  }
}
