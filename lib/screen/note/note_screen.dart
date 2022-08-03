
import 'package:firebase_with_ui/firebase/firebase_note.dart';
import 'package:firebase_with_ui/util/helper.dart';
import 'package:firebase_with_ui/widget/custom_button.dart';
import 'package:flutter/material.dart';

import '../../model/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helper {
  late TextEditingController titleController;
  late TextEditingController infoController;

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController(text: widget.note?.title);
    infoController = TextEditingController(text: widget.note?.info);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          getTitleName(),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.title),
                hintText: 'Title'),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: infoController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.info_outline),
                hintText: 'info'),
          ),
          const SizedBox(height: 20),
          CustomButton(
              title: 'Save',
              onPress: () async {
                await _performSave();
              })
        ],
      ),
    );
  }

  String getTitleName() => isNewNote() ? 'Create Note' : 'Update Note';

  Future<void> _performSave() async {
    if (checkData()) {
      await _save();
    }
  }

  bool checkData() {
    if (titleController.text.isNotEmpty && infoController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required Data ', error: true);
    return false;
  }

  Future<void> _save() async {
    bool status = isNewNote()
        ? await FirebaseNoteController().create(note: note)
        : await FirebaseNoteController().update(note: note);
    String message =
        status ? 'Note saved Successfully ' : 'Note failed Successfully';
    showSnackBar(context, message: message, error: !status);
    if(isNewNote()){
      clear();
    }else{
      Navigator.pop(context);
    }
  }
 void clear(){
    titleController.text = '';
    infoController.text = '';
 }
  Note get note {
    Note note = isNewNote() ? Note() : widget.note!;
    note.title = titleController.text;
    note.info = infoController.text;
    return note;
  }

  bool isNewNote() => widget.note == null;
}
