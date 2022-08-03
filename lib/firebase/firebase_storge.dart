
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> save({required File file}) async {
    UploadTask uploadTask = _firebaseStorage
        .ref('images/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
    uploadTask.snapshotEvents.listen((event) {
      if (uploadTask.snapshot.state == TaskState.success) {
        //
      } else {
        //
      }
    });
  }

  Future<bool> delete({required String path}) async {
    return _firebaseStorage
        .ref(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<List<Reference>> read() async {
    ListResult listResult = await _firebaseStorage.ref('images').listAll();
    if(listResult.items.isNotEmpty){
      return listResult.items;
    }
    return [];
  }
}
