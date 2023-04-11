import 'package:flutter/material.dart';

import 'data.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
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
          return const Center(child: Text("Loading Data..."));
        }

        return Center(
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
              ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: Icon(Icons.add),
                  label: Text("Add Hit"))
            ],
          ),
        );
      },
    );
  }
}
