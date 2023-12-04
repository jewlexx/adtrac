import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import 'auth.dart' show signInWithGoogle;
import 'common.dart';
import 'data.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  var uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => signInWithGoogle().then((cred) {
                  print("Signed in");
                  setState(() => uid = cred.user?.uid);
                }).catchError(print),
                child: const Text("Sign In With Google"),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const NavigationBottomBar(selectedPage: 0),
      );
    }

    var counter = Counter(uid!);

    return FutureBuilder<int>(
        future: counter.count,
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(title),
              ),
              body: const Center(child: Text('Loading Data...')),
            );
          }

          var count = snapshot.data!;

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Hits Today:',
                  ),
                  Text(
                    "$count",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => setState(() async {
                      await counter.increment();
                    }),
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
