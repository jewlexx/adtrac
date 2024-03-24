import 'package:addictiontracker/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common.dart';
import 'data.dart';

class HistoricalPage extends StatefulWidget {
  const HistoricalPage({super.key});

  @override
  State<HistoricalPage> createState() => _HistoricalPageState();
}

class _HistoricalPageState extends State<HistoricalPage> {
  late List<QueryDocumentSnapshot<CountDate>> _allDays;

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      // TODO: Use page redirects rather than component
      return Scaffold(
        body: Center(
          child: SignIn(
            setUid: (newUid) => setState(() => uid = newUid),
          ),
        ),
        bottomNavigationBar: const NavigationBottomBar(selectedPage: 0),
      );
    }

    var userData = UserDataHandler(uid: uid);

    var docs = userData.userCounts.get().then((value) => value.docs);

    return FutureBuilder(
        future: docs,
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Past Counts"),
              ),
              body: const Center(child: Text("Loading Data...")),
            );
          }

          _allDays = snapshot.data!.toList();
          _allDays.sort((a, b) =>
              parseDate(b.data().date).compareTo(parseDate(a.data().date)));

          return Scaffold(
            appBar: AppBar(
              title: const Text(title),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _allDays.clear();
                    });
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
                IconButton(
                  onPressed: () {
                    // counts.import().then((value) => setState(() {}));
                  },
                  icon: const Icon(Icons.upload),
                ),
                // IconButton(
                //   onPressed: counts.export,
                //   icon: const Icon(Icons.download),
                // ),
              ],
            ),
            body: Center(
              child: ListView(
                children: [
                  for (var day in _allDays)
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          day.data().toCounter().delete().then(
                                (value) => setState(() {
                                  _allDays.remove(day);
                                  _allDays.sort((a, b) =>
                                      parseDate(b.data().date)
                                          .compareTo(parseDate(a.data().date)));
                                }),
                              );
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 100, right: 100),
                      title: Text(formatDate(parseDate(day.data().date))),
                      trailing: Text(day.data().count.toString()),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: const NavigationBottomBar(selectedPage: 1),
          );
        });
  }
}

DateTime parseDate(String date) {
  List<int> info = date.split(" ").map((part) => int.parse(part)).toList();
  return DateTime(
    info[0],
    info[1],
    info[2],
  );
}

String formatDate(DateTime date) {
  DateFormat format = DateFormat("yMMMMd");

  return format.format(date);
}
