import 'package:flutter/material.dart';
import '../models/evaluation_model.dart';

class EvaluationProvider extends ChangeNotifier {
  final List<EvaluationModel> _evaluations = [];
  List<EvaluationModel> get evaluations => List.unmodifiable(_evaluations);

  Future<void> fetch() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _evaluations
      ..clear()
      ..addAll([
        EvaluationModel(
          id: 'e1',
          courseId: 'c1',
          topic: 'Linear Algebra',
          questions: ['Q1', 'Q2'],
        ),
      ]);
    notifyListeners();
  }

  Future<void> add(EvaluationModel e) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _evaluations.add(e);
    notifyListeners();
  }
}
