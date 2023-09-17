import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, FirebaseFirestore;

String date() {
  DateTime now = DateTime.now();
  return "${now.year} ${now.month} ${now.day}";
}

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
  }

  Future<void> increment() async {
    setCount((await count) + 1);
  }

  Future<void> setCount(int value) {
    return _doc.update({date(): value});
  }

  DocumentReference<Map<String, dynamic>> get _doc {
    return db.collection("hits").doc(uid);
  }
}
