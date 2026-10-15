import 'package:flutter/material.dart';

import '../../../models/study_note.dart';
import 'add_note_screen.dart';
import '../services/hive_service.dart';

class NoteDetailsScreen extends StatelessWidget {
  final StudyNote note;

  const NoteDetailsScreen({super.key, required this.note});

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Note?'),
          content: Text(
            'Are you sure you want to delete "${note.title}"? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await HiveService.deleteNote(note.id);

    if (!context.mounted) return;

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),

        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit note',
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNoteScreen(note: note),
                ),
              );

              if (updated == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete note',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Topic: ${note.topic}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Created: ${note.createdAt.toLocal().toString().split('.').first}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 32),
            Text(note.content, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
