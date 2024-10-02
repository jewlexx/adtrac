import 'dart:async';

import 'package:adtrac/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String datePrefix = "counts:";

class OnDeviceUserData extends DataProvider {
  final SharedPreferencesAsync prefs;
  final String dateKey;

  final StreamController<CountDate> todayStream = StreamController.broadcast();
  final StreamController<Map<String, int>> allCountsStream =
      StreamController.broadcast();

  OnDeviceUserData({super.date})
      : prefs = SharedPreferencesAsync(),
        dateKey = "$datePrefix$date";

  @override
  Future<Map<String, int>> allCounts() async {
    var allCounts = <String, int>{};

    final keys = await prefs.getKeys();
    final dateKeys = keys.where((key) => key.startsWith("$datePrefix$date"));

    Future.forEach(dateKeys, (key) async {
      allCounts[key.split(":")[1]] = (await prefs.getInt(key))!;
    });

    return allCounts;
  }

  @override
  Future<void> increment() async {
    return setCount(await getCount() + 1);
  }

  @override
  Future<void> decrement() async {
    await setCount(await getCount() - 1);
  }

  @override
  Future<int> getCount() async {
    final currentCount = await prefs.getInt(dateKey);

    if (currentCount == null) {
      await setCount(0);
      return 0;
    } else {
      return currentCount;
    }
  }

  @override
  Future<void> setCount(int newCount) async {
    await prefs.setInt(dateKey, newCount);

    todayStream.add(CountDate(count: newCount, date: date));
    allCountsStream.add(await allCounts());
  }

  @override
  Stream<CountDate> stream() {
    return todayStream.stream;
  }

  @override
  Stream<Map<String, int>> streamAll() {
    return allCountsStream.stream;
  }
}
