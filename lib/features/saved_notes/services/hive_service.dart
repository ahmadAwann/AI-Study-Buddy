import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../../models/study_note.dart';

class HiveService {
  static const String _boxName = 'studyNotesBox';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Map>(_boxName);
    }
  }

  static Box<Map> get _notesBox => Hive.box<Map>(_boxName);

  static Future<void> saveNote(StudyNote note) async {
    await _notesBox.put(note.id, {
      'id': note.id,
      'title': note.title,
      'topic': note.topic,
      'content': note.content,
      'createdAt': note.createdAt.toIso8601String(),
    });
  }

  static List<StudyNote> getAllNotes() {
    return _notesBox.values.map((data) {
      return StudyNote(
        id: data['id'] as String,
        title: data['title'] as String,
        topic: data['topic'] as String,
        content: data['content'] as String,
        createdAt: DateTime.parse(data['createdAt'] as String),
      );
    }).toList();
  }

  static StudyNote? getNote(String id) {
    final data = _notesBox.get(id);

    if (data == null) {
      return null;
    }

    return StudyNote(
      id: data['id'] as String,
      title: data['title'] as String,
      topic: data['topic'] as String,
      content: data['content'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }

  static Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  static Future<void> updateNote(StudyNote note) async {
    await saveNote(note);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
