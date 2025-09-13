class CourseModel {
  final String id;
  final String title;
  final String level; // e.g., "200"
  final String? description;

  CourseModel({
    required this.id,
    required this.title,
    required this.level,
    this.description,
  });

  factory CourseModel.fromJson(Map<String, dynamic> j) => CourseModel(
    id: j['_id'] ?? j['id'] ?? '',
    title: j['title'] ?? '',
    level: j['level']?.toString() ?? '',
    description: j['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'level': level,
    'description': description,
  };
}
