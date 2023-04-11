import "package:flutter/material.dart";
import "package:vapetracker/data.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You"ll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn"t reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Vape Tracker"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: FutureBuilder<VapeCount>(
            future: _counter,
            builder: (BuildContext ctx, AsyncSnapshot<VapeCount> snapshot) {
              var children = <Widget>[
                const Text(
                  "Hits Today:",
                ),
                Text(
                  "${snapshot.data?.count}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ];

              if (snapshot.data == null) {
                children = <Widget>[
                  const Text(
                    "Loading hits...",
                  ),
                ];
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: "Increment",
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
