import 'package:adtrac/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserData extends DataProvider {
  final String uid;
  FirebaseFirestore db;

  FirebaseUserData({required this.uid, super.date})
      : db = FirebaseFirestore.instance;

  @override
  Future<int> getCount({String? date}) async {
    await checkOrInit();

    final doc = await userCounts.doc(date).get();
    final int? current = doc.data()?.count;

    if (current == null) {
      setCount(0);
      return 0;
    } else {
      return current;
    }
  }

  @override
  Future<void> setCount(int newCount) async {
    await docRef.update({'count': newCount});
  }

  @override
  Future<void> increment() async {
    await checkOrInit();

    await docRef.update({
      'count': FieldValue.increment(1),
    });
  }

  @override
  Future<void> decrement() async {
    await checkOrInit();

    await docRef.update({
      'count': FieldValue.increment(-1),
    });
  }

  @override
  Future<Map<String, int>> allCounts() async {
    var counts = await userCounts.get();

    var countsMap = <String, int>{};

    for (var doc in counts.docs) {
      countsMap[doc.id] = doc.data().count;
    }

    return countsMap;
  }

  @override
  Stream<CountDate> stream() {
    return userCounts.doc(date).snapshots().map((snapshot) => snapshot.data()!);
  }

  @override
  Stream<Map<String, int>> streamAll() {
    return userCounts.snapshots().map(
      (snapshot) {
        var counts = <String, int>{};

        for (var doc in snapshot.docs) {
          counts[doc.id] = doc.data().count;
        }

        return counts;
      },
    );
  }

  @override
  Future<void> delete() async {
    await userCounts.doc(date).delete();
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

  DocumentReference<CountDate> get docRef {
    return userCounts.doc(date);
  }

  Future<void> checkOrInit() async {
    if (!(await docRef.get()).exists) {
      docRef.set(CountDate(count: 0, date: date));
    }
  }
}
