import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_with_ui/model/note.dart';

class FirebaseNoteController {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  // Crud

  Future<bool> create({required Note note}) async {
    return await _instance
        .collection('Notes')
        .add(note.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> delete({required String path}) async {
    return _instance
        .collection('Notes')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<void> update({required Note note}) async {
    _instance
        .collection('Notes')
        .doc(note.id)
        .update(note.toMap())
        .then((value) => true)
        .catchError((onError) => false);
  }

  Stream<QuerySnapshot<Note>> read() async* {
    Stream<QuerySnapshot<Note>> querySnapshot = _instance
        .collection('Notes')
        .withConverter<Note>(
          fromFirestore: (snapshot, options) => Note.fromMap(snapshot.data()!),
          toFirestore: (Note note, options) => note.toMap(),
        )
        .snapshots();
    // querySnapshot.transform();
  }
}
