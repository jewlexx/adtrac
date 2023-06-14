import 'package:flutter/material.dart';

import 'common.dart';
import 'data.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final Future<Counter> _vapeCount = Counter.init();

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

          var counter = snapshot.data!;

          return Scaffold(
            body: Center(
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
                    onPressed: () => setState(() => counter.increment()),
                    icon: const Icon(Icons.add),
                    label: const Text("Add Hit"),
                  )
                ],
              ),
            ),
            bottomNavigationBar: const NavigationBottomBar(selectedPage: 0),
          );
        });
  }
}
