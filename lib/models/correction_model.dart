class CorrectionModel {
  final String id;
  final String evaluationId;
  final String answerKey; // could be JSON string or rich text
  final String? notes;

  CorrectionModel({
    required this.id,
    required this.evaluationId,
    required this.answerKey,
    this.notes,
  });

  factory CorrectionModel.fromJson(Map<String, dynamic> j) => CorrectionModel(
    id: j['_id'] ?? j['id'] ?? '',
    evaluationId: j['evaluationId'] ?? '',
    answerKey: j['answerKey'] ?? '',
    notes: j['notes'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'evaluationId': evaluationId,
    'answerKey': answerKey,
    'notes': notes,
  };
}
