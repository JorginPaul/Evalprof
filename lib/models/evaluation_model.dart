class EvaluationModel {
  final String id;
  final String courseId;
  final String topic;
  final List<String> questions;

  EvaluationModel({
    required this.id,
    required this.courseId,
    required this.topic,
    required this.questions,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> j) => EvaluationModel(
    id: j['_id'] ?? j['id'] ?? '',
    courseId: j['courseId'] ?? '',
    topic: j['topic'] ?? '',
    questions:
        (j['questions'] as List?)?.map((e) => e.toString()).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'topic': topic,
    'questions': questions,
  };
}
