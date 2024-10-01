import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

import '../common.dart';
import '../data.dart';
import '../app_bar.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    // if (user == null) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     Navigator.of(context).pushReplacementNamed("/sign-in");
    //   });
    //   return Container();
    // }

    var counter = Counter(userData: UserDataHandler(uid: user.uid));

    return StreamBuilder(
        stream: counter.stream(),
        builder: (ctx, snapshot) {
          return Scaffold(
            appBar: AdTracAppBar(title: "Today's Count", user: user),
            body: snapshot.data == null
                ? const Center(child: Text('Loading Data...'))
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Today's Count:",
                        ),
                        Text(
                          "${snapshot.data!.data()?.count ?? 0}",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                counter.decrement();
                              },
                              icon: const Icon(Icons.remove),
                              label: const Text("Subtract"),
                            ),
                            const Padding(padding: EdgeInsets.all(5.0)),
                            ElevatedButton.icon(
                              onPressed: () {
                                counter.increment();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Add"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            bottomNavigationBar: const NavigationBottomBar(selectedPage: 0),
          );
        });
  }
}
