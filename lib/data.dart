import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
// import 'package:share_plus/share_plus.dart';
import "package:shared_preferences/shared_preferences.dart";

class Counter {
  late SharedPreferences instance;
  bool readying = false;
  // VapeCount({this.instance});

  static Future<Counter> init() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    Counter value = Counter();
    value.instance = instance;

    // Checks that the instance has not already been initialized
    // and that the instance is not in the process of being initialized.
    String currentDate = Counter.date();

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
    String date = Counter.date();
    int? count = instance.getInt(date);

    if (count == null) {
      instance.setInt(date, 0);
      return 0;
    }

    return count;
  }

  set count(int newCount) {
    instance.setInt(Counter.date(), newCount);
  }

  void export() {
    CounterExport export = CounterExport(instance);
    export.share();
  }

  void import() {
    CounterExport import = CounterExport(instance);
    import.import().then(
      (value) {
        if (value != null) {
          instance.setInt(Counter.date(), 0);
          value.counts.forEach((key, value) {
            instance.setInt(key, value as int);
          });
        }
      },
    );
  }
}

class CounterExport {
  Map<String, Object> counts = {};

  CounterExport(SharedPreferences? prefs) {
    if (prefs != null) {
      Set<String> keys = prefs.getKeys();

      for (String key in keys) {
        Object? count = prefs.get(key);
        counts[key] = count!;
      }
    }
  }

  factory CounterExport.fromJson(Map<String, dynamic> json) {
    var export = CounterExport(null);
    for (String key in json.keys) {
      export.counts[key] = json[key] as int;
    }

    return export;
  }

  void share() async {
    String jsonString = json.encode(counts);
    Uint8List bytes = jsonString.parseUtf8();

    await FileSaver.instance.saveAs(
      name: "counts",
      ext: "json",
      bytes: bytes,
      mimeType: MimeType.json,
    );

    // XFile file = XFile.fromData(bytes, mimeType: "application/json");

    // await Share.shareXFiles([file]);
  }

  Future<CounterExport?> import() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (result != null) {
      File file = result.paths.map((path) => File(path!)).toList()[0];
      var data = await file.readAsBytes();
      var parsedData = data.parseUtf8();
      Map<String, dynamic> counts = jsonDecode(parsedData);

      return CounterExport.fromJson(counts);
    } else {
      return null;
    }
  }
}

extension ToUint8List on String {
  Uint8List parseUtf8() {
    List<int> utf8String = utf8.encode(this);
    Uint8List bytes = Uint8List(utf8String.length);
    for (int i = 0; i < utf8String.length; i++) {
      bytes[i] = utf8String[i];
    }

    return bytes;
  }
}

extension ToString on Uint8List {
  String parseUtf8() {
    List<int> utf8String = [];
    for (int i = 0; i < length; i++) {
      utf8String.add(this[i]);
    }

    return utf8.decode(utf8String);
  }
}
