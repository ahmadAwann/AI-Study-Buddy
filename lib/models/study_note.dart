import '../core/utils/id_generator.dart';

class StudyNote {
  final String id;
  final String title;
  final String topic;
  final String content;
  final DateTime createdAt;

  StudyNote({
    String? id,
    required this.title,
    required this.topic,
    required this.content,
    required this.createdAt,
  }) : id = id ?? IdGenerator.generate();
}
