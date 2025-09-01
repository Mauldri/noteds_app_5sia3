import 'package:flutter/material.dart';
import 'package:noteds_app_5sia3/database/database_helper.dart';
import 'package:noteds_app_5sia3/models/note_model.dart';
import 'package:noteds_app_5sia3/notes/notes_screen.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  Future<void> createNote() async {
    try {
      int result = await db.createNote(
        NoteModel(
          noteTitle: titleController.text,
          noteContent: contentController.text,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      if (!mounted) return;

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Note created successfully!'),
            backgroundColor: Colors.teal[400],
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigasi ke halaman Notes
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotesScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create note. Please try again.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while creating the note.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("created note"),
        actions: [
          IconButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {}
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // textformfield untuk input judul
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title is Required";
                  }
                  return null;
                },
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // teztfield untuk input isi catatan
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Content is Required";
                  }
                  return null;
                },
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "content",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}