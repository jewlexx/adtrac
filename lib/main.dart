import "package:flutter/material.dart";
import "package:vapetracker/data.dart";

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
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
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
  final Future<VapeCount> _counter = VapeCount.init();

  void _incrementCounter() {
    setState(() {
      _counter.then((value) => value.increment());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _counter,
        builder: (BuildContext ctx, AsyncSnapshot<VapeCount> snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: const Center(child: Text("Loading Data...")),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Hits Today:",
                  ),
                  Text(
                    "${snapshot.data?.count}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: "Increment",
              child: const Icon(Icons.add),
            ),
            persistentFooterButtons: [
              IconButton(
                onPressed: CounterExport(snapshot.data?.instance).export,
                icon: const Icon(Icons.save),
              ),
            ],
          );
        });
  }
}
