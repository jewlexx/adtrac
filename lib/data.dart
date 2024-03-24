import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_file_dialog/flutter_file_dialog.dart';
// import 'package:file_saver/file_saver.dart';
// import 'package:share_plus/share_plus.dart';
import "package:shared_preferences/shared_preferences.dart";

class UserDataHandler {
  final String uid;
  late FirebaseFirestore db;

  UserDataHandler({required this.uid}) {
    db = FirebaseFirestore.instance;
  }

  DocumentReference<Map<String, dynamic>> get userDoc {
    return db.collection("users").doc(uid);
  }

  CollectionReference<CountDate> get userCounts {
    return userDoc.collection("counts").withConverter<CountDate>(
          fromFirestore: CountDate.fromFirestore,
          toFirestore: CountDate.toFirestore,
        );
  }
}

class CountDate {
  int count;
  String date;

  CountDate({required this.count, required this.date});

  CountDate.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> data, SnapshotOptions? opts)
      : this(count: data.get("count"), date: data.get("date"));

  static Map<String, Object?> toFirestore(CountDate data, SetOptions? opts) {
    return {'count': data.count, 'date': data.date};
  }

  Counter toCounter() {
    return Counter(
      userData: UserDataHandler(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
      date: date,
    );
  }
}

class Counter {
  UserDataHandler userData;
  late String date;

  Counter({required this.userData, String? date}) {
    if (date == null) {
      this.date = currentDate();
    } else {
      this.date = date;
    }
  }

  DocumentReference<CountDate> get docRef {
    return userData.userCounts.doc(date);
  }

  static String currentDate() {
    DateTime now = DateTime.now();
    return "${now.year} ${now.month} ${now.day}";
  }

  Future<void> increment() async {
    int oldCount = await count;

    setCount(oldCount + 1);
  }

  Future<int> get count async {
    final doc = await docRef.get();

    if (!doc.exists) {
      docRef.set(CountDate(count: 0, date: date));
    }

    final int? current = doc.data()?.count;

    if (current == null) {
      setCount(0);
      return 0;
    } else {
      return current;
    }
  }

  Future<void> setCount(int newCount) async {
    await docRef.update({'count': newCount});
  }

  Future<void> delete() async {
    await docRef.delete();
  }

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

  // Future<CounterExport?> import() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ["json"],
  //   );

  //   if (result != null) {
  //     File file = result.paths.map((path) => File(path!)).toList()[0];
  //     var data = await file.readAsBytes();
  //     var parsedData = data.parseUtf8();
  //     Map<String, dynamic> counts = jsonDecode(parsedData);

  //     return CounterExport.fromJson(counts);
  //   } else {
  //     return null;
  //   }
  // }
}

// extension ToUint8List on String {
//   Uint8List parseUtf8() {
//     List<int> utf8String = utf8.encode(this);
//     Uint8List bytes = Uint8List(utf8String.length);
//     for (int i = 0; i < utf8String.length; i++) {
//       bytes[i] = utf8String[i];
//     }

//   Future<void> setCount(int value) {
//     return _doc.update({date(): value});
//   }

//   DocumentReference<Map<String, dynamic>> get _doc {
//     return db.collection("hits").doc(uid);
//   }
//   return bytes;
//   }
// }

// extension ToString on Uint8List {
//   String parseUtf8() {
//     List<int> utf8String = [];
//     for (int i = 0; i < length; i++) {
//       utf8String.add(this[i]);
//     }
//   }