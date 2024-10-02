import 'dart:convert';
import 'dart:io';

import 'package:adtrac/data/device.dart';
import 'package:adtrac/data/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_file_dialog/flutter_file_dialog.dart';
// import 'package:file_saver/file_saver.dart';
// import 'package:share_plus/share_plus.dart';

String currentDate() {
  DateTime now = DateTime.now();
  return "${now.year} ${now.month} ${now.day}";
}

abstract class DataProvider {
  String date;

  static DataProvider getDefault() {
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return OnDeviceUserData();
    } else {
      return FirebaseUserData(uid: user.uid);
    }
  }

  static DataProvider defaultWithDate({required String date}) {
    final provider = getDefault();
    provider.date = date;

    return provider;
  }

  DataProvider({String? date}) : date = date ?? currentDate();

  Future<Map<String, int>> allCounts();

  Future<int> getCount();
  Future<void> setCount(int newCount);
  Future<void> increment();
  Future<void> decrement();

  Future<void> delete();

  Stream<CountDate> stream();
  Stream<Map<String, int>> streamAll();

  // Stream<DocumentSnapshot<CountDate>> stream() {
  //   return docRef.snapshots();
  // }

  // Future<void> import() async {
  //   CounterExport import = CounterExport(instance);
  //   var value = await import.import();
  //   if (value != null) {
  //     value.counts.forEach((key, value) {
  //       instance.setInt(key, value as int);
  //     });
  //   }
  // }
}

class CountDate {
  String date;
  int count;

  CountDate({required this.count, required this.date});

  CountDate.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> data, SnapshotOptions? opts)
      : this(count: data.get("count"), date: data.get("date"));

  static Map<String, Object?> toFirestore(CountDate data, SetOptions? opts) {
    return {'count': data.count, 'date': data.date};
  }
}

extension ToDataProvider on MapEntry<String, int> {
  DataProvider toUserData() {
    return DataProvider.defaultWithDate(date: key);
  }
}

class CounterExport {
  Map<String, int> counts;

  CounterExport({this.counts = const {}});

  // void share() async {
  //   String jsonString = json.encode(counts);
  //   Uint8List bytes = jsonString.parseUtf8();

  // if (!await FlutterFileDialog.isPickDirectorySupported()) {
  //   throw 'Picking directory not supported';
  // }

  // final pickedDirectory = await FlutterFileDialog.pickDirectory();

  // if (pickedDirectory != null) {
  //   await FlutterFileDialog.saveFileToDirectory(
  //     directory: pickedDirectory,
  //     data: bytes,
  //     mimeType: "application/json",
  //     fileName: "counts.json",
  //     replace: false,
  //   );
  // }

  // await FileSaver.instance.saveAs(
  //   name: "counts",
  //   ext: "json",
  //   bytes: bytes,
  //   mimeType: MimeType.json,
  // );

  //   // XFile file = XFile.fromData(bytes, mimeType: "application/json");

  //   // await Share.shareXFiles([file]);
  // }

  static Future<CounterExport?> import() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (result != null) {
      File file = result.paths.map((path) => File(path!)).toList()[0];
      var data = await file.readAsBytes();
      var parsedData = data.parseUtf8();
      Map<String, int> counts = jsonDecode(parsedData);

      return CounterExport(counts: counts);
    } else {
      return null;
    }
  }

  Future<void> upload() async {
    for (var date in counts.keys) {
      final provider = DataProvider.defaultWithDate(date: date);
      await provider.setCount(counts[date] as int);
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

    return String.fromCharCodes(utf8String);
  }
}
