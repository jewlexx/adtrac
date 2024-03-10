import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
// import 'package:share_plus/share_plus.dart';
import "package:shared_preferences/shared_preferences.dart";

class Counter {
  String uid;
  late FirebaseFirestore db;

  Counter(this.uid) {
    db = FirebaseFirestore.instance;
  }
  // static Future<Counter> init() async {}

  Future<int> get count async {
    var doc = await db.collection("hits").doc(uid).get();
    int? current = doc.get(date());

    if (current == null) {
      await setCount(0);
      return 0;
    } else {
      return current;
    }

    return count;
  }

  set count(int newCount) {
    instance.setInt(Counter.date(), newCount);
    export.share();
  }

  Future<void> import() async {
    CounterExport import = CounterExport(instance);
    var value = await import.import();
    if (value != null) {
      value.counts.forEach((key, value) {
        instance.setInt(key, value as int);
      });
    }
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

  Future<void> setCount(int value) {
    return _doc.update({date(): value});
  }

  DocumentReference<Map<String, dynamic>> get _doc {
    return db.collection("hits").doc(uid);
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
  }