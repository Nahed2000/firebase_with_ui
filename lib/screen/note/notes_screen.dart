import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_with_ui/firebase/firebase_auth.dart';
import 'package:firebase_with_ui/firebase/firebase_note.dart';
import 'package:firebase_with_ui/screen/note/note_screen.dart';
import 'package:firebase_with_ui/util/helper.dart';
import 'package:flutter/material.dart';

import '../../model/note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with Helper {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notes Screen',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/image_screen');
            },
            icon: const Icon(
              Icons.camera,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoteScreen(),
                  ));
            },
            icon: const Icon(Icons.note_add_outlined),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuthController().logeOut();
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: const Icon(
              Icons.login_outlined,
              color: Colors.black,
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot<Note>>(
          stream: FirebaseNoteController().read(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) => ListTile(
                  onTap: () async {
                    navigatorToUpdateNoteScreen(
                      snapshot,
                      index,
                    );
                  },
                  title: Text(snapshot.data!.docs[index].data().title),
                  subtitle: Text(snapshot.data!.docs[index].data().info),
                  leading: const Icon(Icons.note),
                  trailing: IconButton(
                    onPressed: () async {
                      await _delete(path: snapshot.data!.docs[index].id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                    ),
                    SizedBox(height: 20),
                    Text("don't have any data")
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<void> _delete({required String path}) async {
    bool status = await FirebaseNoteController().delete(path: path);
    String message =
        status ? 'Note deleted Successfully ' : 'Note deleted failed';
    showSnackBar(context, message: message, error: !status);
  }

  void navigatorToUpdateNoteScreen(
    AsyncSnapshot<QuerySnapshot<Note>> snapshot,
    int index,
  ) {
    QueryDocumentSnapshot<Note> noteSnapshot = snapshot.data!.docs[index];
    Note note = noteSnapshot.data();
    note.id = noteSnapshot.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteScreen(note: note),
      ),
    );
  }
}
