import 'dart:async';

import 'package:adtrac/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String datePrefix = "counts:";

class OnDeviceUserData extends DataProvider {
  final SharedPreferencesAsync prefs;
  late String dateKey;

  final StreamController<CountDate> todayStream = StreamController.broadcast();
  final StreamController<Map<String, int>> allCountsStream =
      StreamController.broadcast();

  OnDeviceUserData({super.date}) : prefs = SharedPreferencesAsync() {
    dateKey = "$datePrefix$date";
    init();
  }

  Future<void> init() async {
    await pushStreams();

    todayStream.onListen = pushTodayStream;
    allCountsStream.onListen = pushAllCountsStream;
  }

  @override
  Future<Map<String, int>> allCounts() async {
    var allCounts = <String, int>{};

    final keys = await prefs.getKeys();
    final dateKeys = keys.where((key) {
      if (!key.startsWith(datePrefix)) {
        return false;
      }

      try {
        parseDate(key.split(":")[1]);
        return true;
      } catch (_) {
        return false;
      }
    });

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
    await pushStreams();
  }

  @override
  Future<void> delete() async {
    await prefs.remove(dateKey);
    await pushStreams();
  }

  @override
  Stream<CountDate> stream() {
    return todayStream.stream;
  }

  @override
  Stream<Map<String, int>> streamAll() {
    return allCountsStream.stream;
  }

  Future<void> pushStreams() async {
    pushTodayStream();
    pushAllCountsStream();
  }

  Future<void> pushTodayStream() async {
    todayStream.add(CountDate(count: await getCount(), date: date));
  }

  Future<void> pushAllCountsStream() async {
    allCountsStream.add(await allCounts());
  }
}
