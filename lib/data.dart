import 'package:share_plus/share_plus.dart';
import "package:shared_preferences/shared_preferences.dart";

class VapeCount {
  late SharedPreferences instance;
  bool readying = false;
  // VapeCount({this.instance});

  static Future<VapeCount> init() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    VapeCount value = VapeCount();
    value.instance = instance;

    // Checks that the instance has not already been initialized
    // and that the instance is not in the process of being initialized.
    String? date = instance.getString("date");
    String currentDate = VapeCount.date();

    if (date == null || date != currentDate) {
      await instance.setString("date", currentDate);
      await instance.setInt("count", 0);
    }

    return value;
  }

  static String date() {
    DateTime now = DateTime.now();
    return "${now.year} ${now.month} ${now.day}";
  }

  void increment() {
    count += 1;
  }

  int get count {
    int? count = instance.getInt("count");
    return count!;
  }

  set count(int newCount) {
    instance.setInt("count", newCount);
  }
}

class CounterExport {
  Map<String, Object> counts = {};

  CounterExport(SharedPreferences? prefs) {
    Set<String> keys = prefs!.getKeys();

    for (String key in keys) {
      Object? count = prefs.get(key);
      counts[key] = count!;
    }
  }

  void export() {
    String jsonString = counts.toString();

    Share.share(jsonString);
  }
}
