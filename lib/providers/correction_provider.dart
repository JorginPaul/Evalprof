import 'package:flutter/material.dart';
import '../models/correction_model.dart';

class CorrectionProvider extends ChangeNotifier {
  final List<CorrectionModel> _corrections = [];
  List<CorrectionModel> get corrections => List.unmodifiable(_corrections);

  Future<void> fetch() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _corrections
      ..clear()
      ..addAll([
        CorrectionModel(
          id: 'k1',
          evaluationId: 'e1',
          answerKey: '1) A\n2) C',
          notes: 'Be precise',
        ),
      ]);
    notifyListeners();
  }

  Future<void> add(CorrectionModel c) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _corrections.add(c);
    notifyListeners();
  }
}
