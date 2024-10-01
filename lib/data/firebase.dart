import 'package:adtrac/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserData extends UserDataHandler {
  final String uid;
  late FirebaseFirestore db;

  FirebaseUserData({required this.uid, String? date})
      : super(date: date ?? currentDate()) {
    db = FirebaseFirestore.instance;
  }

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
    await docRef().update({'count': newCount});
  }

  @override
  Future<void> increment() async {
    await checkOrInit();

    await docRef().update({
      'count': FieldValue.increment(1),
    });
  }

  @override
  Future<void> decrement() async {
    await checkOrInit();

    await docRef().update({
      'count': FieldValue.increment(-1),
    });
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

  DocumentReference<CountDate> docRef() {
    return userCounts.doc(date);
  }

  Future<void> checkOrInit() async {
    if (!(await docRef.get()).exists) {
      docRef.set(CountDate(count: 0, date: date));
    }
  }
}
