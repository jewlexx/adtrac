import 'package:adtrac/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String datePrefix = "counts:";

class OnDeviceUserData extends UserDataHandler {
  final SharedPreferencesAsync prefs;
  final String dateKey;

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
  Future<void> decrement() {
    // TODO: implement decrement
    throw UnimplementedError();
  }

  @override
  Future<int> getCount() {
    // TODO: implement getCount
    throw UnimplementedError();
  }

  @override
  Future<void> increment() {
    // TODO: implement increment
    throw UnimplementedError();
  }

  @override
  Future<void> setCount(int newCount) {
    // TODO: implement setCount
    throw UnimplementedError();
  }
}
