import 'package:flutter/material.dart';
import '../models/course_model.dart';

class CourseProvider extends ChangeNotifier {
  final List<CourseModel> _courses = [];
  List<CourseModel> get courses => List.unmodifiable(_courses);

  Future<void> fetch() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _courses
      ..clear()
      ..addAll([
        CourseModel(id: 'c1', title: 'Mathematics', level: '200'),
        CourseModel(id: 'c2', title: 'Computer Science', level: '300'),
      ]);
    notifyListeners();
  }

  Future<void> add(CourseModel c) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _courses.add(c);
    notifyListeners();
  }
}
