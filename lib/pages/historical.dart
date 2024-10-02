import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common.dart';
import '../app_bar.dart';
import '../data.dart';

class HistoricalPage extends StatefulWidget {
  const HistoricalPage({super.key});

  @override
  State<HistoricalPage> createState() => _HistoricalPageState();
}

class _HistoricalPageState extends State<HistoricalPage> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.of(context).pushReplacementNamed("/sign-in");
      return Container();
    }

    var userData = DataProvider.getDefault();
    final allCounts = userData.allCounts();

    var docs = userData.userCounts.snapshots().map((value) => value.docs);

    return StreamBuilder(
        stream: docs,
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return const Scaffold(
              body: Center(child: Text("Loading Data...")),
            );
          }

          var days = snapshot.data!.toList();
          days.sort((a, b) =>
              parseDate(b.data().date).compareTo(parseDate(a.data().date)));

          return Scaffold(
            appBar: AdTracAppBar(
              title: "Past Counts",
              user: user,
              actions: [
                IconButton(
                  onPressed: () {
                    for (var day in days) {
                      day.data().toCounter().delete();
                    }
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
                IconButton(
                  onPressed: () async {
                    var export = (await CounterExport.import());

                    if (export != null) {
                      await export.upload(userData.userCounts);
                    }
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
                  for (var day in days)
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          day.data().toCounter().delete();
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
