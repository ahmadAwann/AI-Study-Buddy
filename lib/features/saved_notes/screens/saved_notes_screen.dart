import 'package:flutter/material.dart';

import '../../../models/study_note.dart';
import '../services/hive_service.dart';
import 'add_note_screen.dart';

class SavedNotesScreen extends StatefulWidget {
  const SavedNotesScreen({super.key});

  @override
  State<SavedNotesScreen> createState() => _SavedNotesScreenState();
}

class _SavedNotesScreenState extends State<SavedNotesScreen> {
  late List<StudyNote> _notes;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    _notes = HiveService.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Notes')),
      body: _notes.isEmpty
          ? const Center(child: Text('No saved notes yet.'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];

                return ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(note.title),
                  subtitle: Text(note.topic),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );

          if (saved == true && mounted) {
            setState(() {
              _loadNotes();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
