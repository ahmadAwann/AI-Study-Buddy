import 'package:flutter/material.dart';

import '../../../models/study_note.dart';
import '../services/hive_service.dart';
import 'add_note_screen.dart';
import 'note_details_screen.dart';

class SavedNotesScreen extends StatefulWidget {
  const SavedNotesScreen({super.key});

  @override
  State<SavedNotesScreen> createState() => _SavedNotesScreenState();
}

class _SavedNotesScreenState extends State<SavedNotesScreen> {
  late List<StudyNote> _notes;

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    _notes = HiveService.getAllNotes();
  }

  List<StudyNote> get _filteredNotes {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _notes;
    }

    return _notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.topic.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Notes')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or topic...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _filteredNotes.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No saved notes yet.'
                          : 'No matching notes found.',
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = _filteredNotes[index];

                      return ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(note.title),
                        subtitle: Text(note.topic),
                        trailing: const Icon(Icons.chevron_right),

                        onTap: () async {
                          final updated = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailsScreen(note: note),
                            ),
                          );

                          if (updated == true && mounted) {
                            setState(() {
                              _loadNotes();
                            });
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
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
