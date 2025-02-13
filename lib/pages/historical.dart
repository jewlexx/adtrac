import 'package:flutter/material.dart';

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
    var userData = DataProvider.getDefault();

    return StreamBuilder(
        stream: userData.streamAll(),
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return const Scaffold(
              body: Center(child: Text("Loading Data...")),
            );
          }

          var days = snapshot.data!.entries.toList();
          days.sort((a, b) => parseDate(b.key).compareTo(parseDate(a.key)));

          return Scaffold(
            appBar: AdTracAppBar(
              title: "Past Counts",
              actions: [
                IconButton(
                  onPressed: () {
                    for (var day in days) {
                      day.toUserData().delete();
                    }
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
                IconButton(
                  onPressed: () async {
                    var export = (await CounterExport.import());

                    if (export != null) {
                      await export.upload();
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
                          day.toUserData().delete();
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 100, right: 100),
                      title: Text(formatDate(parseDate(day.key))),
                      trailing: Text(day.value.toString()),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: const NavigationBottomBar(selectedPage: 1),
          );
        });
  }
}
