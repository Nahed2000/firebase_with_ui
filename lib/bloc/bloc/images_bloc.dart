import 'dart:ffi';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_with_ui/bloc/event/crud_event.dart';
import 'package:firebase_with_ui/bloc/state/crud_state.dart';
import 'package:firebase_with_ui/firebase/firebase_storge.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagesBloc extends Bloc<CrudEvent, CrudState> {
  ImagesBloc(CrudState initialState) : super(initialState) {
    on<CreateEvent>(_create);
    on<ReadEvent>(_read);
    on<DeleteEvent>(_delete);
  }

  final FirebaseStorageController _firebaseStorageController =
      FirebaseStorageController();
  List<Reference> references = <Reference>[];

  void _create(CreateEvent event, Emitter emit) async {
    UploadTask uploadTask = _firebaseStorageController.save(file: event.file);

   await uploadTask.snapshotEvents.listen((event) {
      if (uploadTask.snapshot.state == TaskState.success) {
        references.add(event.ref);
        emit(ProcessState(
          processType: ProcessType.create,
          status: true,
          message: 'Uploaded Successfully',
        ));
      } else if(event.state == TaskState.error){
        emit(ProcessState(
          processType: ProcessType.create,
          status: false,
          message: 'Uploaded Failed',
        ));
      }
    }).asFuture();
  }

  void _read(ReadEvent event, Emitter emit) async {
    references = await _firebaseStorageController.read();
    emit(ReadState(data: references));
  }

  void _delete(DeleteEvent event, Emitter emit) async {
    // bool deleted = await _firebaseStorageController.delete(path: event.path);
    //if(deleted){
    // int index = references.indexWhere((element) => event.fullPath==event.path);
    //if(index !=-1){
    // references.removeAt(index);
    // }
    // }
    bool deleted = await _firebaseStorageController.delete(
        path: references[event.index].fullPath);
    if (deleted){
      references.removeAt(event.index);
      emit(ReadState(data: references));
    }
      
    String message = deleted ? 'deleted Successfully ' : 'deleted failed';

    emit(ProcessState(
      processType: ProcessType.delete,
      status: deleted,
      message: message,
    ));
  }
}
