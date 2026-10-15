import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:ai_study_buddy/features/saved_notes/services/hive_service.dart';
import 'package:ai_study_buddy/models/study_note.dart';

void main() {
  setUp(() async {
    Hive.init('./test_hive_data');
    await HiveService.init();

    // Start each test with an empty database.
    await Hive.box<Map>('studyNotesBox').clear();
  });

  tearDown(() async {
    await HiveService.close();
  });

  test('Save and retrieve a study note', () async {
    final note = StudyNote(
      id: 'note_001',
      title: 'Neural Networks',
      topic: 'Machine Learning',
      content: 'Neural networks learn patterns from data.',
      createdAt: DateTime(2026, 10, 14),
    );

    await HiveService.saveNote(note);

    final savedNote = HiveService.getNote('note_001');

    expect(savedNote, isNotNull);
    expect(savedNote!.title, 'Neural Networks');
    expect(savedNote.topic, 'Machine Learning');
    expect(savedNote.content, 'Neural networks learn patterns from data.');
  });

  test('Update a study note', () async {
    final note = StudyNote(
      id: 'note_002',
      title: 'Old Title',
      topic: 'Flutter',
      content: 'Old content',
      createdAt: DateTime(2026, 10, 14),
    );

    await HiveService.saveNote(note);

    final updatedNote = StudyNote(
      id: note.id,
      title: 'New Title',
      topic: note.topic,
      content: 'Updated content',
      createdAt: note.createdAt,
    );

    await HiveService.updateNote(updatedNote);

    expect(HiveService.getNote(note.id)!.title, 'New Title');
  });

  test('Delete a study note', () async {
    final note = StudyNote(
      id: 'note_003',
      title: 'Delete Me',
      topic: 'Testing',
      content: 'This note will be deleted.',
      createdAt: DateTime(2026, 10, 14),
    );

    await HiveService.saveNote(note);
    await HiveService.deleteNote(note.id);

    expect(HiveService.getNote(note.id), isNull);
  });

  test('A saved note remains after closing and reopening Hive', () async {
    final note = StudyNote(
      id: 'persistent_001',
      title: 'Gradient Descent',
      topic: 'Machine Learning',
      content: 'Gradient descent minimizes a loss function.',
      createdAt: DateTime(2026, 10, 14),
    );

    await HiveService.saveNote(note);

    // Close the database.
    await HiveService.close();

    // Reinitialize Hive using the same test directory.
    Hive.init('./test_hive_data');
    await HiveService.init();

    // Retrieve the previously saved note.
    final retrievedNote = HiveService.getNote('persistent_001');

    expect(retrievedNote, isNotNull);
    expect(retrievedNote!.title, 'Gradient Descent');
    expect(
      retrievedNote.content,
      'Gradient descent minimizes a loss function.',
    );
  });

  test('Retrieve all saved notes', () async {
    final note1 = StudyNote(
      id: 'all_001',
      title: 'Linear Regression',
      topic: 'Machine Learning',
      content: 'Predicts continuous values.',
      createdAt: DateTime(2026, 10, 14),
    );

    final note2 = StudyNote(
      id: 'all_002',
      title: 'Flutter Basics',
      topic: 'Flutter',
      content: 'Flutter builds cross-platform apps.',
      createdAt: DateTime(2026, 10, 14),
    );

    await HiveService.saveNote(note1);
    await HiveService.saveNote(note2);

    final notes = HiveService.getAllNotes();

    expect(notes.length, 2);
    expect(notes.any((note) => note.id == 'all_001'), isTrue);
    expect(notes.any((note) => note.id == 'all_002'), isTrue);
  });

  test('Generate unique IDs for new notes', () {
    final note1 = StudyNote(
      title: 'Linear Regression',
      topic: 'Machine Learning',
      content: 'Predict continuous values.',
      createdAt: DateTime.now(),
    );

    final note2 = StudyNote(
      title: 'Flutter Basics',
      topic: 'Flutter',
      content: 'Build cross-platform applications.',
      createdAt: DateTime.now(),
    );

    expect(note1.id, isNotEmpty);
    expect(note2.id, isNotEmpty);
    expect(note1.id, isNot(note2.id));
  });

  test('Save two notes with generated IDs without overwriting', () async {
    final note1 = StudyNote(
      title: 'Linear Regression',
      topic: 'Machine Learning',
      content: 'Predicts continuous values.',
      createdAt: DateTime.now(),
    );

    final note2 = StudyNote(
      title: 'Flutter Basics',
      topic: 'Flutter',
      content: 'Build cross-platform applications.',
      createdAt: DateTime.now(),
    );

    await HiveService.saveNote(note1);
    await HiveService.saveNote(note2);

    final retrievedNote1 = HiveService.getNote(note1.id);
    final retrievedNote2 = HiveService.getNote(note2.id);

    expect(retrievedNote1, isNotNull);
    expect(retrievedNote2, isNotNull);
    expect(retrievedNote1!.title, 'Linear Regression');
    expect(retrievedNote2!.title, 'Flutter Basics');
    expect(note1.id, isNot(note2.id));
  });
}
