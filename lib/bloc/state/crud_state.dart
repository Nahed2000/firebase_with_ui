import 'package:firebase_storage/firebase_storage.dart';

enum ProcessType { create, delete }

abstract class CrudState {}

class LoadingState extends CrudState {}

class ReadState extends CrudState {
  final List<Reference> data;

  ReadState({required this.data});
}

class ProcessState extends CrudState {
  final ProcessType processType;
  final bool status;
  final String message;

  ProcessState({
    required this.processType,
    required this.status,
    required this.message,
  });
}
