import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import '../common.dart';
import '../data.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed("/sign-in");
      });
      return Container();
    }

    var counter = Counter(userData: UserDataHandler(uid: uid));

    return StreamBuilder(
        stream: counter.stream(),
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(title),
              ),
              body: const Center(child: Text('Loading Data...')),
            );
          }

          final count = snapshot.data!.data()?.count ?? 0;

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Today's Count:",
                  ),
                  Text(
                    "$count",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      counter.increment();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  )
                ],
              ),
            ),
            bottomNavigationBar: const NavigationBottomBar(selectedPage: 0),
          );
        });
  }
}
