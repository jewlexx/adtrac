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
  final Future<Counter> _vapeCount = Counter.init();
  late List<String> _allDays;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _vapeCount,
        builder: (BuildContext ctx, AsyncSnapshot<Counter> snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Past Counts"),
              ),
              body: const Center(child: Text("Loading Data...")),
            );
          }

          var counter = snapshot.data!;

          Set<String> keys = counter.instance.getKeys();
          _allDays = keys.toList();
          _allDays.sort((a, b) => parseDate(b).compareTo(parseDate(a)));

          return Scaffold(
            appBar: AppBar(
              title: const Text(title),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      counter.instance.clear();
                      _allDays = [];
                    });
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
                IconButton(
                  onPressed: counter.export,
                  icon: const Icon(Icons.download),
                ),
                IconButton(
                  onPressed: counter.import,
                  icon: const Icon(Icons.upload),
                )
              ],
            ),
            body: Center(
              child: ListView(
                children: [
                  for (String day in _allDays)
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          setState(() {
                            counter.instance.remove(day);

                            Set<String> keys = counter.instance.getKeys();

                            _allDays = keys.toList();
                            _allDays.sort(
                              (a, b) => parseDate(b).compareTo(parseDate(a)),
                            );
                          });
                        },
                        icon: const Icon(Icons.delete_forever),
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 100, right: 100),
                      title: Text(formatDate(parseDate(day))),
                      trailing: Text(counter.instance.getInt(day).toString()),
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
