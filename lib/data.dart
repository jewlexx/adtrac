import 'dart:convert';
import 'dart:typed_data';

// import 'package:file_saver/file_saver.dart';
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
    String currentDate = VapeCount.date();

    if (instance.getInt(currentDate) == null) {
      await instance.setInt(currentDate, 0);
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
    String date = VapeCount.date();
    int? count = instance.getInt(date);

    if (count == null) {
      instance.setInt(date, 0);
      return 0;
    }

    return count;
  }

  set count(int newCount) {
    instance.setInt(VapeCount.date(), newCount);
  }

  void export() {
    CounterExport export = CounterExport(instance);
    export.share();
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

  void share() async {
    String jsonString = json.encode(counts);
    Uint8List bytes = stringToBytes(jsonString);
    XFile file = XFile.fromData(bytes, mimeType: "application/json");

    await Share.shareXFiles([file]);
  }
}

Uint8List stringToBytes(String str) {
  List<int> utf8String = utf8.encode(str);
  Uint8List bytes = Uint8List(utf8String.length);
  for (int i = 0; i < utf8String.length; i++) {
    bytes[i] = utf8String[i];
  }

  return bytes;
}
