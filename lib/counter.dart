import 'package:flutter/material.dart';

import 'data.dart';

class CounterPage extends StatefulWidget {
  final VapeCount counter;

  const CounterPage({super.key, required this.counter});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  void _incrementCounter() {
    setState(() => super.widget.counter.increment());
  }

  @override
  Widget build(BuildContext context) {
    VapeCount counter = super.widget.counter;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Hits Today:",
          ),
          Text(
            "${counter.count}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ElevatedButton.icon(
            onPressed: _incrementCounter,
            icon: const Icon(Icons.add),
            label: const Text("Add Hit"),
          )
        ],
      ),
    );
  }
}
