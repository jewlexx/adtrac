import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data.dart';

class HistoricalPage extends StatefulWidget {
  final VapeCount counter;

  const HistoricalPage({super.key, required this.counter});

  @override
  State<HistoricalPage> createState() => _HistoricalPageState();
}

class _HistoricalPageState extends State<HistoricalPage> {
  void deleteDay(String day) {
    super.widget.counter.instance.remove(day);
  }

  @override
  Widget build(BuildContext context) {
    VapeCount counter = super.widget.counter;

    Set<String> allDays = counter.instance.getKeys();

    return Center(
      child: ListView(
        children: [
          for (String day in allDays)
            ListTile(
              leading: IconButton(
                onPressed: () => deleteDay(day),
                icon: const Icon(Icons.delete_forever),
              ),
              contentPadding: const EdgeInsets.only(left: 100, right: 100),
              title: Text(formatDate(parseDate(day))),
              trailing: Text(counter.instance.getInt(day).toString()),
            ),
        ],
      ),
    );
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
