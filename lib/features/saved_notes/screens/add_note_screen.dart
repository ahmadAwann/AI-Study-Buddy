import 'package:flutter/material.dart';

import '../../../models/study_note.dart';
import '../services/hive_service.dart';

class AddNoteScreen extends StatefulWidget {
  final StudyNote? note;

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _topicController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final note = widget.note;

    if (note != null) {
      _titleController.text = note.title;
      _topicController.text = note.topic;
      _contentController.text = note.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _topicController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final existingNote = widget.note;

      final note = StudyNote(
        id: existingNote?.id,
        title: _titleController.text.trim(),
        topic: _topicController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: existingNote?.createdAt ?? DateTime.now(),
      );

      await HiveService.saveNote(note);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existingNote == null
                ? 'Note saved successfully!'
                : 'Note updated successfully!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save note. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Study Note' : 'Edit Study Note'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Note Title',
                  hintText: 'e.g. Introduction to Flutter',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a note title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(
                  labelText: 'Topic',
                  hintText: 'e.g. Mobile App Development',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a topic.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                minLines: 6,
                maxLines: 12,
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  hintText: 'Write your study notes here...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter note content.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isSaving ? null : _saveNote,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
