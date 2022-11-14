import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference notekepperRef;

  void connectWithCollection() {
    notekepperRef = firebaseFirestore.collection("notekepper");
  }

  Future<void> insertRecords(data) async {
    connectWithCollection();

    await notekepperRef.add(data);
  }

  Future<void> updateRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectWithCollection();

    await notekepperRef.doc(id).update(data);
  }

  Stream<QuerySnapshot> selectRecords() {
    connectWithCollection();

    return notekepperRef.snapshots();
  }

  deleteRecords({required String id}) async {
    connectWithCollection();

    await notekepperRef.doc(id).delete();
  }
}
